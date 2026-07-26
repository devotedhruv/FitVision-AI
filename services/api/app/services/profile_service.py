"""Profile business rules and transaction coordination."""

from sqlalchemy.ext.asyncio import AsyncSession

from app.repositories.profile_repository import ProfileRepository
from app.schemas.auth import CurrentUserClaims
from app.schemas.profile import ProfileUpdate


class ProfileService:
    def __init__(self, session: AsyncSession):
        self.session = session
        self.repository = ProfileRepository(session)

    async def get_or_create(self, user: CurrentUserClaims):
        async with self.session.begin():
            fallback = user.email.split("@")[0] if user.email else "FitVision User"
            profile = await self.repository.ensure(user.user_id, fallback[:100])
            await self.repository.ensure_identity(
                user.user_id, user.identity_provider, user.provider_subject
            )
            return profile

    async def update(self, user: CurrentUserClaims, data: ProfileUpdate):
        async with self.session.begin():
            fallback = user.email.split("@")[0] if user.email else "FitVision User"
            profile = await self.repository.ensure(user.user_id, fallback[:100])
            await self.repository.ensure_identity(
                user.user_id, user.identity_provider, user.provider_subject
            )
            return await self.repository.update(profile, data)

    async def delete_owned_data(self, user: CurrentUserClaims) -> None:
        """Transactionally remove the API profile and every cascaded child row."""
        async with self.session.begin():
            profile = await self.repository.get(user.user_id)
            if profile is not None:
                await self.repository.delete(profile)
