class ExternalLinkInfo {
  final String title;
  final String? description;
  final String url;
  final String? tag;

  ExternalLinkInfo({
    required this.title,
    this.description,
    required this.url,
    this.tag,
  });

  static List<ExternalLinkInfo> getAllExternalLinks({String? searchQuery}) {
    return [
      ExternalLinkInfo(
        title: "DUT Official Home Page",
        description: "The official DUT home page",
        tag: "official",
        url: "https://dut.udn.vn",
      ),
      ExternalLinkInfo(
        title: "DUT Student Information System",
        description: "The official DUT student page.",
        tag: "official",
        url: "https://sv.dut.udn.vn",
      ),
      ExternalLinkInfo(
        title: "Forum link",
        description: "A area which student can leave a question or a request.",
        tag: "official",
        url: "https://fr.dut.udn.vn",
      ),
      ExternalLinkInfo(
        title: "School rule documents",
        description: "All documents about school rules and regulations.",
        tag: "official",
        url: "https://1drv.ms/u/s!AtwKlDZ6Vqbto10bhHc0K7seyNGr?eaCTb8x",
      ),
      ExternalLinkInfo(
        title: "DUT Library",
        description: null,
        tag: "official",
        url: "http://lib.dut.udn.vn",
      ),
      ExternalLinkInfo(
        title: "DUT on Facebook - Official",
        description: "The official facebook link for DUT",
        tag: "social",
        url: "https://www.facebook.com/bachkhoaDUT",
      ),
      ExternalLinkInfo(
        title: "DUT on Facebook - Department of Student Affairs",
        description: "A DUT facebook page for official update about school and its social.",
        tag: "social",
        url: "https://www.facebook.com/ctsvdhbkdhdn",
      ),
      ExternalLinkInfo(
        title: "Forgot student account password - How to reset",
        description:
            "This article will explain how to reset student account password (as this won't be shown in student page).",
        tag: "social",
        url:
            "https://www.facebook.com/ctsvdhbkdhdn/posts/pfbid02dHKp7h9gd2qPsfK3n4veQ7gfD9mJ3af2Mgz8V2vt5z6WAXPXstRwzu9Vd8iHjEgfl",
      ),
    ].where((p) {
      return p.title.toLowerCase().contains(searchQuery?.toLowerCase() ?? "") ||
          p.url.toLowerCase().contains(searchQuery?.toLowerCase() ?? "") ||
          (p.description?.toLowerCase().contains(searchQuery?.toLowerCase() ?? "") ?? false);
    }).toList();
  }
}
