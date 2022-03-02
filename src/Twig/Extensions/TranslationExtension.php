<?php

namespace App\Twig\Extensions;

use Slim\Views\TwigExtension;

class TranslationExtension extends TwigExtension
{
    public $translator;

    public function __construct($translator)
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
            new \Twig\TwigFunction('__', array($this, 'translate'))
        );
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
}
