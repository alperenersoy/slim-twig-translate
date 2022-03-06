<?php

namespace App\Twig\Extensions;

use Illuminate\Translation\Translator;
use Slim\Views\TwigExtension;

class TranslationExtension extends TwigExtension
{
    public $translator;

    public function __construct(Translator $translator)
    {
        $this->translator = $translator;
    }

    public function getName(): string
    {
        return 'translate';
    }

    public function getFunctions(): array
    {
        return array(
            new \Twig\TwigFunction('translate', array($this, 'translate')),
            new \Twig\TwigFunction('trans', array($this, 'translate')),
            new \Twig\TwigFunction('__', array($this, 'translate')),
            new \Twig\TwigFunction('getLocale', array($this, 'getLocale')),
            new \Twig\TwigFunction('hasTranslation', array($this, 'hasTranslation')),
            new \Twig\TwigFunction('trans_choice', array($this, 'trans_choice')),
            new \Twig\TwigFunction('translator', array($this, 'translator')),
        );
    }

    public function translator()
    {
        return $this->translator;
    }

    public function translate($key, array $replace = [], $locale = null, $fallback = true)
    {
        if (!$this->translator) {
            throw new \Exception('No translator class found.');
        }
        if (!method_exists($this->translator, 'get')) {
            throw new \Exception('No translate method found in translator class.');
        }
        return $this->translator->get($key, $replace, $locale, $fallback);
    }

    public function trans_choice($key, $number, array $replace = [], $locale = null)
    {
        if (!$this->translator) {
            throw new \Exception('No translator class found.');
        }
        if (!method_exists($this->translator, 'choice')) {
            throw new \Exception('No choice method found in translator class.');
        }
        return $this->translator->choice($key, $number, $replace, $locale);
    }

    public function getLocale()
    {
        if (!$this->translator) {
            throw new \Exception('No translator class found.');
        }
        if (!method_exists($this->translator, 'getLocale')) {
            throw new \Exception('No getLocale method found in translator class.');
        }
        return $this->translator->getLocale();
    }

    public function hasTranslation($key, $locale = null, $fallback = true)
    {
        if (!$this->translator) {
            throw new \Exception('No translator class found.');
        }
        if (!method_exists($this->translator, 'has')) {
            throw new \Exception('No has method found in translator class.');
        }
        return $this->translator->has($key, $locale, $fallback);
    }
}
