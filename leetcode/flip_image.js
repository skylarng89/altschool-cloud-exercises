let flipAndInvertImage = function (image) {
    let firstLength = image.length;
    let secondLength = Math.ceil(firstLength / 2);
    for (let a = 0; a < firstLength; a++) {
        for (let b = 0; b < secondLength; b++) {
            if (b !== firstLength - b - 1) {
                imageSwap(image[a], b, firstLength - b - 1);
                reverse(image[a], firstLength - b - 1);
            }
            reverse(image[a], b);
        }
    }
    return image;
};

let imageSwap = function (arr, a, b) {
    let img = arr[a];
    arr[a] = arr[b];
    arr[b] = img;
};

let reverse = function (arr, a) {
    arr[a] = arr[a] ? 0 : 1;
};