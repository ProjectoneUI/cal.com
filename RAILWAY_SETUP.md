# Railway Environment Variables for Cal.com

Copy these environment variables to your Railway project settings.
Go to: Railway Dashboard → Your Project → Variables

## Required Environment Variables

```env
# Database (your Railway PostgreSQL)
DATABASE_URL=postgresql://postgres:crmJRCnmZEYCKlOitgwLdwyvgQlHNmAR@tramway.proxy.rlwy.net:46817/railway
DATABASE_DIRECT_URL=postgresql://postgres:crmJRCnmZEYCKlOitgwLdwyvgQlHNmAR@tramway.proxy.rlwy.net:46817/railway

# Public URLs (your Railway domain)
NEXT_PUBLIC_WEBAPP_URL=https://rcalcom.up.railway.app
NEXT_PUBLIC_WEBSITE_URL=https://rcalcom.up.railway.app
NEXTAUTH_URL=https://rcalcom.up.railway.app
NEXT_PUBLIC_API_V2_URL=https://rcalcom.up.railway.app/api/v2

# Authentication Secrets (already generated - from your .env file)
NEXTAUTH_SECRET=Cl+ve6bxhi9TASPd/6BH+sZunCGXujZY/DGPyX06f8E=
CALENDSO_ENCRYPTION_KEY=bilCOuP/MDNGII6KDsAfXOwRp2J17YRm4QYNiv5yIkk=

# License & Build Settings
NEXT_PUBLIC_LICENSE_CONSENT=agree
CALCOM_TELEMETRY_DISABLED=1

# Cron API Key
CRON_API_KEY=0cc0e6c35519bba620c9360cfe3e68d0

# App Settings
EMAIL_FROM=notifications@rcalcom.up.railway.app
EMAIL_FROM_NAME=Cal.com
NEXT_PUBLIC_APP_NAME=Cal.com
NEXT_PUBLIC_SUPPORT_MAIL_ADDRESS=help@rcalcom.up.railway.app
NEXT_PUBLIC_COMPANY_NAME=Cal.com

# Build Settings
MAX_OLD_SPACE_SIZE=8192
NODE_ENV=production
TZ=UTC
```

## Build Configuration in Railway

Railway will automatically detect the Dockerfile. The build will:
1. Install dependencies
2. Build the Next.js application
3. Run Prisma migrations on start
4. Start the web server

## After Deployment

1. Visit https://rcalcom.up.railway.app
2. The setup wizard will appear to create your first user
3. Complete the setup!

## Troubleshooting

If the build fails:
- Check Railway's build logs for specific errors
- Ensure all environment variables are set correctly
- Railway's build may take 10-20 minutes for Cal.com (it's a large app)

If you see SSL errors:
- Add `NODE_TLS_REJECT_UNAUTHORIZED=0` temporarily (only if needed)
