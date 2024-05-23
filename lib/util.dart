String ellipsis(String src, int n) =>
    src.length > n ? '${src.substring(0, n - 1)}...' : src;
