<?php

namespace App\Helpers;

/**
 * Class ArrayHelper
 * Useful array utilities with dot-notation support.
 */
class ArrayHelper
{
    /**
     * Get an item from an array using "dot" notation.
     *
     * @param array $array
     * @param string|null $key
     * @param mixed $default
     * @return mixed
     */
    public static function get(array $array, $key, $default = null)
    {
        if ($key === null || $key === '') {
            return $array;
        }

        if (array_key_exists($key, $array)) {
            return $array[$key];
        }

        foreach (explode('.', $key) as $segment) {
            if (!is_array($array) || !array_key_exists($segment, $array)) {
                return $default;
            }
            $array = $array[$segment];
        }

        return $array;
    }

    /**
     * Set an item on an array using "dot" notation.
     *
     * @param array &$array
     * @param string $key
     * @param mixed $value
     * @return void
     */
    public static function set(array &$array, $key, $value)
    {
        if ($key === null || $key === '') {
            return;
        }

        $segments = explode('.', $key);
        while (count($segments) > 1) {
            $segment = array_shift($segments);
            if (!isset($array[$segment]) || !is_array($array[$segment])) {
                $array[$segment] = [];
            }
            $array = &$array[$segment];
        }
        $array[array_shift($segments)] = $value;
    }

    /**
     * Determine if the given key exists in the array using dot notation.
     *
     * @param array $array
     * @param string $key
     * @return bool
     */
    public static function has(array $array, $key)
    {
        if ($key === null || $key === '') {
            return false;
        }

        if (array_key_exists($key, $array)) {
            return true;
        }

        foreach (explode('.', $key) as $segment) {
            if (!is_array($array) || !array_key_exists($segment, $array)) {
                return false;
            }
            $array = $array[$segment];
        }

        return true;
    }

    /**
     * Remove one or many array items from a given array using dot notation.
     *
     * @param array &$array
     * @param string|array $keys
     * @return void
     */
    public static function forget(array &$array, $keys)
    {
        $original =& $array;
        $keys = is_array($keys) ? $keys : [$keys];

        foreach ($keys as $key) {
            $array =& $original;
            if (array_key_exists($key, $array)) {
                unset($array[$key]);
                continue;
            }

            $parts = explode('.', $key);
            while (count($parts) > 1) {
                $part = array_shift($parts);
                if (!isset($array[$part]) || !is_array($array[$part])) {
                    continue 2;
                }
                $array =& $array[$part];
            }
            unset($array[array_shift($parts)]);
        }
    }

    /**
     * Pluck values from an array of arrays/objects.
     *
     * @param array $array
     * @param string|callable $valueKey
     * @param string|null $indexKey
     * @return array
     */
    public static function pluck(array $array, $valueKey, $indexKey = null)
    {
        $results = [];

        foreach ($array as $item) {
            $value = is_callable($valueKey) ? $valueKey($item) : self::getItemValue($item, $valueKey);
            if ($indexKey === null) {
                $results[] = $value;
            } else {
                $index = is_callable($indexKey) ? $indexKey($item) : self::getItemValue($item, $indexKey);
                $results[$index] = $value;
            }
        }

        return $results;
    }

    /**
     * Index an array by a given key.
     *
     * @param array $array
     * @param string|callable $key
     * @return array
     */
    public static function indexBy(array $array, $key)
    {
        $results = [];
        foreach ($array as $item) {
            $index = is_callable($key) ? $key($item) : self::getItemValue($item, $key);
            $results[$index] = $item;
        }
        return $results;
    }

    /**
     * Flatten a multi-dimensional array.
     *
     * @param array $array
     * @param int $depth
     * @return array
     */
    public static function flatten(array $array, $depth = PHP_INT_MAX)
    {
        $result = [];

        foreach ($array as $item) {
            if (!is_array($item)) {
                $result[] = $item;
            } elseif ($depth === 1) {
                foreach ($item as $v) {
                    $result[] = $v;
                }
            } else {
                $result = array_merge($result, self::flatten($item, $depth - 1));
            }
        }

        return $result;
    }

    /**
     * Merge arrays recursively but do not convert scalar value to array.
     * Later arrays override earlier values (except when both are arrays, they are merged).
     *
     * @param array ...$arrays
     * @return array
     */
    public static function mergeRecursiveDistinct(...$arrays)
    {
        $base = array_shift($arrays);
        if (!is_array($base)) {
            $base = [];
        }

        foreach ($arrays as $append) {
            if (!is_array($append)) {
                continue;
            }
            foreach ($append as $key => $value) {
                if (array_key_exists($key, $base) && is_array($base[$key]) && is_array($value)) {
                    $base[$key] = self::mergeRecursiveDistinct($base[$key], $value);
                } else {
                    $base[$key] = $value;
                }
            }
        }

        return $base;
    }

    /**
     * Return first element (optionally matching callback) or default.
     *
     * @param array $array
     * @param callable|null $callback
     * @param mixed $default
     * @return mixed
     */
    public static function first(array $array, callable $callback = null, $default = null)
    {
        if ($callback === null) {
            foreach ($array as $v) {
                return $v;
            }
            return $default;
        }

        foreach ($array as $k => $v) {
            if ($callback($v, $k)) {
                return $v;
            }
        }

        return $default;
    }

    /**
     * Return last element (optionally matching callback) or default.
     *
     * @param array $array
     * @param callable|null $callback
     * @param mixed $default
     * @return mixed
     */
    public static function last(array $array, callable $callback = null, $default = null)
    {
        if ($callback === null) {
            if (empty($array)) {
                return $default;
            }
            return end($array);
        }

        foreach (array_reverse($array, true) as $k => $v) {
            if ($callback($v, $k)) {
                return $v;
            }
        }

        return $default;
    }

    /**
     * Determine if array contains a given value (strict optional).
     *
     * @param array $array
     * @param mixed $value
     * @param bool $strict
     * @return bool
     */
    public static function contains(array $array, $value, $strict = false)
    {
        foreach ($array as $item) {
            if ($strict ? $item === $value : $item == $value) {
                return true;
            }
            if (is_array($item) && self::contains($item, $value, $strict)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Group array items by callback or key.
     *
     * @param array $array
     * @param callable|string $groupBy
     * @return array
     */
    public static function groupBy(array $array, $groupBy)
    {
        $results = [];
        foreach ($array as $item) {
            $key = is_callable($groupBy) ? $groupBy($item) : self::getItemValue($item, $groupBy);
            $results[$key][] = $item;
        }
        return $results;
    }

    /**
     * Filter values with callback (wrapper).
     *
     * @param array $array
     * @param callable|null $callback
     * @return array
     */
    public static function filter(array $array, callable $callback = null)
    {
        if ($callback === null) {
            return array_values(array_filter($array));
        }
        return array_values(array_filter($array, $callback, ARRAY_FILTER_USE_BOTH));
    }

    /**
     * Helper to get value from array/object using dot notation for arrays.
     *
     * @param mixed $item
     * @param string $key
     * @return mixed|null
     */
    protected static function getItemValue($item, $key)
    {
        if (is_callable($key)) {
            return $key($item);
        }

        if (is_array($item)) {
            return self::get($item, $key);
        }

        if (is_object($item)) {
            // support nested properties with dot notation
            if (strpos($key, '.') === false) {
                return $item->{$key} ?? null;
            }
            $parts = explode('.', $key);
            $current = $item;
            foreach ($parts as $p) {
                if (is_object($current) && isset($current->{$p})) {
                    $current = $current->{$p};
                } elseif (is_array($current) && array_key_exists($p, $current)) {
                    $current = $current[$p];
                } else {
                    return null;
                }
            }
            return $current;
        }

        return null;
    }
}