import unittest

import gen_docs

DOCKERFILE = '''FROM x
# renovate: datasource=github-releases depName=a/lazygit extractVersion=^v(?<version>.+)$
ARG LAZYGIT_VERSION="0.60.0"
ARG TARGETARCH
# renovate: datasource=node-version depName=node
ARG NODE_VERSION="24.1.0"
ARG NOT_PINNED_VERSION="1"
'''


class GenDocs(unittest.TestCase):
    def test_tool_versions(self):
        self.assertEqual(
            gen_docs.tool_versions(DOCKERFILE),
            [("lazygit", "0.60.0", "a/lazygit"), ("node", "24.1.0", "node")],
        )

    def test_render_and_apply_roundtrip(self):
        block = gen_docs.render(DOCKERFILE, "img:1.3", "img:1.3")
        self.assertIn("| lazygit | 0.60.0 |", block)
        self.assertNotIn("firewall-variant", block)
        page = f"kop\n{gen_docs.BEGIN}\noud\n{gen_docs.END}\nstaart\n"
        out = gen_docs.apply(page, block)
        self.assertTrue(out.startswith("kop\n") and out.endswith("\nstaart\n"))
        self.assertEqual(gen_docs.apply(out, block), out)

    def test_firewall_pin_difference_is_shown(self):
        self.assertIn("firewall-variant", gen_docs.render(DOCKERFILE, "img:1.3", "img:1.2"))

    def test_real_repo_has_tools(self):
        rows = gen_docs.tool_versions(gen_docs.DOCKERFILE.read_text())
        self.assertGreaterEqual(len(rows), 15)


if __name__ == "__main__":
    unittest.main()
