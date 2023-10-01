using Images, TestImages
using DelimitedFiles

idealImgSize = 10

img = Gray.(load("testimage.png"))
horizontalSize, verticalSize = img_size = size(img)
N = 2*idealImgSize + 1

a, b = size(img)
minSize = min(a, b)
xOffset = round(Int64, (size(img, 1) - minSize)/2 + 1)
yOffset = round(Int64, (size(img, 2) - minSize)/2 + 1)

croppedImg = img[xOffset:xOffset + minSize - 1, yOffset:yOffset + minSize - 1]
Img = imresize(croppedImg, (N, N))
idealImg = Float64.(Img)

imageVect = Vector{Float64}()
for i in range(1, N)
    for j in range(1, N)
        pixelBrightness = idealImg[i, j]
        push!(imageVect, pixelBrightness)
    end
end

writedlm("img.txt", imageVect)