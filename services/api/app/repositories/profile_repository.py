"""Profile-only SQLAlchemy queries."""

from uuid import UUID

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.auth_identity import AuthIdentity
from app.models.profile import Profile
from app.schemas.profile import ProfileUpdate


class ProfileRepository:
    def __init__(self, session: AsyncSession):
        self.session = session

    async def get(self, user_id: UUID) -> Profile | None:
        return await self.session.scalar(select(Profile).where(Profile.id == user_id))

    async def ensure(self, user_id: UUID, display_name: str) -> Profile:
        profile = await self.get(user_id)
        if profile is None:
            profile = Profile(id=user_id, display_name=display_name)
            self.session.add(profile)
            await self.session.flush()
        return profile

    async def ensure_identity(
        self,
        user_id: UUID,
        provider: str,
        provider_subject: str | None,
    ) -> None:
        if not provider_subject:
            return
        identity = await self.session.scalar(
            select(AuthIdentity).where(
                AuthIdentity.provider == provider,
                AuthIdentity.provider_subject == provider_subject,
            )
        )
        if identity is None:
            self.session.add(
                AuthIdentity(
                    user_id=user_id,
                    provider=provider,
                    provider_subject=provider_subject,
                )
            )
            await self.session.flush()

    async def update(self, profile: Profile, data: ProfileUpdate) -> Profile:
        for field, value in data.model_dump(exclude_unset=True).items():
            setattr(profile, field, str(value) if field == "avatar_url" and value else value)
        await self.session.flush()
        return profile

    async def delete(self, profile: Profile) -> None:
        """Delete the profile; database cascades remove all owned sessions."""
        await self.session.delete(profile)
