package dreamengine.plugins.input.devices;

import dreamengine.core.math.Vector2i;

interface IPointer{
    public function getPointerPosition():Vector2i;
    public function getPointerDelta():Vector2i;
    
}