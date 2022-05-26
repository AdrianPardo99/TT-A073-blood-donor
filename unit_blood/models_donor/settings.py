import os
import ast
import datetime
import dj_database_url

ENVIRONMENT = os.environ.get("ENVIRONMENT")

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/1.11/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = os.environ.get("SECRET_KEY")

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = ast.literal_eval(os.environ.get("DEBUG", "True"))

ALLOWED_HOSTS = ["*"]


# Application definition

INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    # Local apps
    "api",
    "application_user",
    "blood_center",
    # External apps
    "rest_framework",
    "rest_framework_jwt",
    "psycopg2",
    "dj_database_url",
    "corsheaders",
    "simple_history",
    "dbbackup",
    "records",
]


DBBACKUP_STORAGE = 'django.core.files.storage.FileSystemStorage'
DBBACKUP_STORAGE_OPTIONS = {'location': BASE_DIR/'backup'}

MIDDLEWARE = [
    "corsheaders.middleware.CorsMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
    "simple_history.middleware.HistoryRequestMiddleware",
]

ROOT_URLCONF = "models_donor.urls"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

WSGI_APPLICATION = "models_donor.wsgi.application"


# Database
# https://docs.djangoproject.com/en/1.11/ref/settings/#databases
DATABASE_URL = os.environ.get("DATABASE_URL")
DATABASES = {
    "default": dj_database_url.config(
        default=DATABASE_URL,
        conn_max_age=600,
    ),
}


# Password validation
# https://docs.djangoproject.com/en/1.11/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        "NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.MinimumLengthValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.CommonPasswordValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.NumericPasswordValidator",
    },
]


# Internationalization
# https://docs.djangoproject.com/en/1.11/topics/i18n/

LANGUAGE_CODE = "es"
TIME_ZONE = "UTC"
USE_I18N = True
USE_L10N = False
USE_TZ = True

LANGUAGES = (
    ("en", "English"),
    ("es", "Español"),
)

# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/1.11/howto/static-files/

STATIC_URL = "/static/"

AUTH_USER_MODEL = "application_user.User"

REST_FRAMEWORK = {
    "DEFAULT_PERMISSION_CLASSES": [
        "rest_framework.permissions.IsAuthenticated",
    ],
    "DEFAULT_AUTHENTICATION_CLASSES": [
        "rest_framework_jwt.authentication.JSONWebTokenAuthentication"
    ],
    "DEFAULT_RENDERER_CLASSES": [
        "rest_framework.renderers.JSONRenderer",
    ],
}

if ENVIRONMENT == "local":
    extra_default_renderer_classes = ["rest_framework.renderers.BrowsableAPIRenderer"]
    REST_FRAMEWORK["DEFAULT_RENDERER_CLASSES"] += extra_default_renderer_classes

# Cors Headers

CORS_ORIGIN_ALLOW_ALL = ast.literal_eval(
    os.environ.get("CORS_ORIGIN_ALLOW_ALL", "True")
)

CORS_ALLOW_ALL_ORIGINS = ast.literal_eval(
    os.environ.get("CORS_ALLOW_ALL_ORIGINS", "True")
)

CORS_ALLOW_CREDENTIALS = ast.literal_eval(
    os.environ.get("CORS_ALLOW_CREDENTIALS", "True")
)

CORS_ALLOWED_ORIGINS = ["*"]

# JWT headers
JWT_AUTH = {
    "JWT_ENCODE_HANDLER": "rest_framework_jwt.utils.jwt_encode_handler",
    "JWT_DECODE_HANDLER": "rest_framework_jwt.utils.jwt_decode_handler",
    "JWT_PAYLOAD_HANDLER": "api.jwt.jwt_payload_handler",
    "JWT_PAYLOAD_GET_USER_ID_HANDLER": "rest_framework_jwt.utils.jwt_get_user_id_from_payload_handler",
    "JWT_RESPONSE_PAYLOAD_HANDLER": "api.jwt.jwt_response_payload_handler",
    "JWT_SECRET_KEY": SECRET_KEY,
    "JWT_GET_USER_SECRET_KEY": None,
    "JWT_PUBLIC_KEY": None,
    "JWT_PRIVATE_KEY": None,
    "JWT_ALGORITHM": "HS256",
    "JWT_VERIFY": True,
    "JWT_VERIFY_EXPIRATION": True,
    "JWT_LEEWAY": 0,
    # Expiration in 1 years
    "JWT_EXPIRATION_DELTA": datetime.timedelta(days=365),
    "JWT_AUDIENCE": None,
    "JWT_ISSUER": None,
    "JWT_ALLOW_REFRESH": True,
    "JWT_REFRESH_EXPIRATION_DELTA": datetime.timedelta(days=365),
    "JWT_AUTH_HEADER_PREFIX": "Bearer",
    "JWT_AUTH_COOKIE": None,
}

# Microservices that check if the transfer can do it
PLATELETS_API = os.environ.get("PLATELETS_API")

# Microservices that check if the units in center can transfer
PLASMA_API = os.environ.get("PLASMA_API")

# Microservices that makes knapsack problem
ERYTHROCYTE_API = os.environ.get("ERYTHROCYTE_API")
