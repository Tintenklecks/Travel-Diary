Usage

    @Environment(\.imageCache) var cache: ImageCache

...

        AsyncImage(
           url: url,
           cache: self.cache,
           placeholder: Text("Loading ..."),
           configuration: { $0.resizable() }
        )

