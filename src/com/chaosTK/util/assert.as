package com.chaosTK.util
{
    import flash.errors.IllegalOperationError;

    public function assert(value : Boolean) : void
    {
        if (!value)
        {
            throw new IllegalOperationError();
        }
    }
}
