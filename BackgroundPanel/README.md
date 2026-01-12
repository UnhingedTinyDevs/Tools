# Background Panel
This is a simple panel that can take in a list of images ([CompressedTexture2D](https://docs.godotengine.org/en/stable/classes/class_compressedtexture2d.html)) and display those images as a slide show. If only one image is
provided then the background is displayed as a static image. If no images where given or fail to load they will be replaced with a static 
black background. The Background panel serves as the background in a lot of different UI elements and since it is highly customizable each element
can have a unique feel. If this is being used as part of a larger component then make sure its parents have access to its variables 
and is a tool script to see the updates happen automatically in the editor.

## Parameters
### Slide Show (bool)
if true and more than 2 images are provided the images will cycle over time. If false and more than 2 images are provided a random one will
be displayed as a static image.

### Images (Array[CompressedTexture2D)
A list of [CompressedTexture2D](https://docs.godotengine.org/en/stable/classes/class_compressedtexture2d.html)'s are displayed as background images. Having this makes it easy to drag and drop images into the editor
to use with this background. 

### Duration (float)
How long to stay on an image before swithcing to a new one.

### Transitions (bool)
if true then the slide show uses the provided transition.

### Transition Type (enum)
What kind of transition should be used by the slide show if any. It is an integer enum that is hidden by a selector box.
- FADE
- SLIDE_RIGHT
- SLIDE_LEFT
