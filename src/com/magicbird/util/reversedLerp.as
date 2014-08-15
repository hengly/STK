package com.chaosTK.util
{
    public function reversedLerp(progress : Number, v1 : Number, v2 : Number) : Number
    {
        if (progress <= 0.5)
        {
            return v1 + (v2 - v1) * progress * 2;
        }
        else
        {
            return v1 + (v2 - v1) * (1 - progress) * 2;
        }
    }
}
