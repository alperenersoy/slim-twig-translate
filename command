#!/usr/bin/env php
<?php

require __DIR__ . '/vendor/autoload.php';


$command = $argv[1];

if ($command == 'export-translations') {
    if (!key_exists(2, $argv) || !key_exists(3, $argv) || !key_exists(4, $argv))
        exit(colorize('Parameters missing. Usage: php export-translations templateDir langDir targetLanguage', 'error'));

    $templateDir = $argv[2];
    $langDir = $argv[3];
    $targetLanguage = $argv[4];

    echo colorize('Template directory: ' . $templateDir);
    echo colorize('Language directory: ' . $langDir);
    echo colorize('Target Language: ' . $targetLanguage);

    if (!is_dir($templateDir))
        exit(colorize('Template directory is not a directory.', 'error'));

    if (!is_dir($langDir)) {
        $createLangDir = readline(colorize('Language directory is not a directory. Do you want to create now? Type "yes" or "y" to approve, something else to exit: ', 'warning'));
        if ($createLangDir == 'y' || $createLangDir == 'yes')
            mkdir($langDir, 0755);
        else
            exit();
    }

    $filePath = $langDir . '/' . $targetLanguage . '.json';

    $currentTranslations = json_decode('{}');
    if (is_file($filePath)) {
        if (!empty($content = file_get_contents($filePath)))
            $currentTranslations = json_decode($content);
    }

    $currentTranslationsCount = 0;
    foreach ($currentTranslations as $currentTranslation) {
        $currentTranslationsCount++;
    }

    $newTranslationCount = 0;
    $files = getFiles($templateDir);
    foreach ($files as $file) {
        $content = file_get_contents($file);
        preg_match_all('/(?:__|translate|trans)\((?:\"|\')([^\)]*)(?:\"|\')(\s{0,},\s{0,}{|\))/', $content, $matches, PREG_PATTERN_ORDER);
        $tmpKeys = isset($matches[1]) ? $matches[1] : [];
        foreach ($tmpKeys as $tmpKey) {
            if (!isset($currentTranslations->{$tmpKey})) {
                $currentTranslations->{$tmpKey} = $tmpKey;
                $newTranslationCount++;
            }
        }
    }
    if ($newTranslationCount == 0)
        exit(colorize('No new translations found.', 'warning'));

    if ($currentTranslationsCount > 0)
        $createLangDir = readline(colorize($newTranslationCount . ' translations found. These will be added to ' . $currentTranslationsCount . ' existing one. Type "yes" or "y" to approve, something else to exit:', 'warning'));
    if ($currentTranslationsCount == 0 || $createLangDir == 'y' || $createLangDir == 'yes') {
        $file = fopen($filePath, "w") or die("Unable to open file!");
        fwrite($file, json_encode($currentTranslations, JSON_PRETTY_PRINT));
        fclose($file);
        exit(colorize($newTranslationCount . ' translations successfully added.', 'success'));
    }
}

function getFiles($dir, &$results = array())
{
    $files = scandir($dir);
    foreach ($files as $key => $value) {
        $path = realpath($dir . DIRECTORY_SEPARATOR . $value);
        if (!is_dir($path) && is_file($path)) {
            $results[] = $path;
        } else if ($value != "." && $value != "..") {
            getFiles($path, $results);
        }
    }

    return $results;
}

function colorize($str, $type = 'info')
{
    switch ($type) {
        case 'error':
            return "\033[31m$str \033[0m\n";
            break;
        case 'success':
            return "\033[32m$str \033[0m\n";
            break;
        case 'warning':
            return "\033[33m$str \033[0m";
            break;
        case 'info':
            return "\033[36m$str \033[0m\n";
            break;
        default:
            break;
    }
}

exit();
