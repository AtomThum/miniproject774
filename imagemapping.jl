using Images, TestImages

idealImgSize = 20

img = Gray.(testimage("chelsea"))
horizontalSize, verticalSize = img_size = size(img)
N = 2*idealImgSize + 1

a, b = size(img)
minSize = min(a, b)
xOffset = round(Int64, (size(img, 1) - minSize)/2 + 1)
yOffset = round(Int64, (size(img, 2) - minSize)/2 + 1)

croppedImg = img[xOffset:xOffset + minSize - 1, yOffset:yOffset + minSize - 1]
idealImg = imresize(croppedImg, (idealImgSize, idealImgSize))
display(idealImg)