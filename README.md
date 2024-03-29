# Slim Framework 4 Skeleton Application With Twig Template Engine and Illuminate Translation

It's a starter project which is a modified version of [Slim-Skeleton](https://github.com/slimphp/Slim-Skeleton). Added [slim's official twig helper](https://github.com/slimphp/Twig-View) and [translation extension](https://github.com/dkesberg/slim-twig-translation-extension) with some modifications.

It can help to build small web applications which needs basic routing system, template engine and multilingual functionality.

## Install the Application

### Clone this repository.

```bash
git clone https://github.com/alperenersoy/slim-twig-translate.git
cd slim-twig-translate
```

### Install dependencies

```bash
composer install
```

### Configuration

You can configure twig and translation settings from app/settings.php
```php
'twig' => [
    'templateDir' => '../templates',
    'cache' => false, /*'../var/cache'*/
],
'translator' => [
    'locale' => 'en',
    'fallback' => 'en',
    'folderPath' => '../lang'
]
```

### Serve the Application

To serve this application, run serve command in public folder:

```bash
cd public
php -S localhost:8080
```

## Translation Usage

Put your language files to the directory you specified. You can use JSON files such as lang/en.json or php files like lang/en/home.php.

In your twig template files, call these functions:

```php
trans('key')
translate('key')
__('key')
trans_choice('key', $number) //returns singular or plural translation according to the number variable.
```

You can specify other parameters:

Replaceable variables
```php
__("Our favorite color is :variable.",{'variable':"blue"})
```

Full usage ($key, array $replace = [], $locale = null, $fallback = true)
```php
__("Our favorite color is :variable.", {'variable':"blue"}, "en", true)
```

## Extra

### Other Twig Functions
```php
getLocale() //gets locale e.g. "en".
translator() //returns translator instance itself.
hasTranslation($key, $locale = null, $fallback = true) //checks if translation exists. returns true or false.
```

### PHP CLI Command to Export Translations From Templates

This command helps to export translatable strings from your twig templates.

```bash
php command export-translations <templateDirectory> <languageDirectory> <targetLanguage>
#default example
php command export-translations templates lang en
```

This will create or update lang/en.json with untranslated keys.