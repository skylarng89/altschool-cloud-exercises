let generate = function (number) {
    let a = 0;
    let b = 0;
    let res = [];
    for (a = 0; a < number; a++) {
        res.push(Array(a + 1));
        for (b = 0; b <= a; b++) {
            if (b === 0 || b === a) {
                res[a][b] = 1;
            } else {
                res[a][b] = res[a - 1][b - 1] + res[a - 1][b];
            }
        }
    }
    return res;
};