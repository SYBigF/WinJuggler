#Requires AutoHotkey v2.0

ArraySort(arr) {
    len := arr.Length
    loop len {
        loop len - A_Index {
            i := A_Index
            j := i + 1
            if arr[i] > arr[j] {
                tmp := arr[i]
                arr[i] := arr[j]
                arr[j] := tmp
            }
        }
    }
}

ArrayIndexOf(arr, val) {
    for i, v in arr {
        if (v = val)
            return i
    }
    return 0
}
