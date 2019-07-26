# ImageCollectionSwiper
**By Cassie Scheirer**

A tinder-like application to easily accept/reject images, for manually training neural nets

## Requirements
- Processing 3.4
- Arrow keys

## Instructions
1. Load all your image data into the **source_images** folder (located inside the **data** folder).
2. Run the Processing sketch.
3. When an image loads onto the canvas, press the *left arrow* to send it to the **bad** folder; press the *right arrow* to send it to the **good** folder.
4. Press the *up arrow* to undo the last move. You may only undo the previous choice (you can only go back one level).
5. Each time you run the program, a new session is started. Each choice is recorded on a log file specific to each session located in the **image_logs** folder; a *-1* means it's a bad photo, a *1* means it's a good photo.
6. When you are done with all the photos, the canvas will turn black.

*All of the .gitinclude files are not necessary to the program and may be deleted after cloned/downloaded.*

#### Happy swiping!
