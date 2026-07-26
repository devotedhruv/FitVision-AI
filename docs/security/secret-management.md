# Secret management audit

Backend database credentials and privileged Supabase values are environment-only; mobile accepts the public Supabase URL/publishable key and API URL through build configuration. `.env` variants, private keys, keystores and service configuration files are ignored while placeholder `.env.example` remains trackable.

`scripts/security_scan.py` checks tracked files for recognized private keys, service-role/JWT secrets, credential-bearing database URLs and private evaluation video. It reports only rule and path, never matched material. This is defense in depth, not a replacement for provider secret scanning or rotation after exposure. No git-history credential conclusion is made unless history is explicitly scanned.
