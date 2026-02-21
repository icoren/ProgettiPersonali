// bgImg is the background image to be modified.
// fgImg is the foreground image.
// fgOpac is the opacity of the foreground image.
// fgPos is the position of the foreground image in pixels. It can be negative and (0,0) means the top-left pixels of the foreground and background are aligned.
function composite(bgImg, fgImg, fgOpac, fgPos) {
    let NormalizedAlpha;
    let bgWidth = bgImg.width;
    let bgHeight = bgImg.height;
    let fgWidth = fgImg.width;
    let fgHeight = fgImg.height;

    for (let y = 0; y < bgHeight; y++) {
        for (let x = 0; x < bgWidth; x++) {
            let bgIndex = (y * bgWidth + x) * 4;
            let fgX = x - fgPos.x;
            let fgY = y - fgPos.y;

            if (fgX >= 0 && fgX < fgWidth && fgY >= 0 && fgY < fgHeight) {
                let fgIndex = (fgY * fgWidth + fgX) * 4;
                for (let i = 0; i < 3; i++) {
                    NormalizedAlpha = fgImg.data[fgIndex + 3] / 255;
                    bgImg.data[bgIndex + i] = fgOpac * NormalizedAlpha * fgImg.data[fgIndex + i] + (1 - fgOpac * NormalizedAlpha) * bgImg.data[bgIndex + i];
                }
            }
        }
    }
}
