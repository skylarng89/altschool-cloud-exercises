let deleteDuplicates = function (top) {
    let currValue = top;
    while (currValue) {
        if (currValue.next && currValue.next.val === currValue.val) {
            currValue.next = currValue.next.next;
        } else {
            currValue = currValue.next;
        }
    }
    return top;
};