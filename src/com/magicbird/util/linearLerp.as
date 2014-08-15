package com.chaosTK.util
{
    public function linearLerp(progress : Number, v1 : Number, v2 : Number) : Number
    {
        if (progress <= 0.5)
        {
            return v1 + 8 * (v2 - v1) * Math.pow(progress, 4);
        }
        else
        {
            return v2 - 8 * (v2 - v1) * Math.pow(1 - progress, 4);
        }
    }
}

