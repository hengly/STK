package com.chaosTK.util
{
    public class Random
    {
        public static function nextInt(max : int) : int
        {
            return Math.random() * max;
        }

        public static function nextBoolean(prop : Number) : Boolean
        {
            return Math.random() < prop;
        }
    }
}