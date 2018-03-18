local luaunit = require("luaunit")
local xmlua = require("xmlua")

TestCSSSelect = {}

local function css_select(xml, css_selector_groups)
  local document = xmlua.XML.parse(xml)
  local matched_xmls = {}
  for _, node in ipairs(document:css_select(css_selector_groups)) do
    table.insert(matched_xmls, node:to_xml())
  end
  return matched_xmls
end

function TestCSSSelect.test_selector_groups()
  local xml = [[
<root>
  <sub1 class="A"/>
  <sub2 class="A"/>
  <sub1 class="B"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "sub1, sub2"),
                       {
                         [[<sub1 class="A"/>]],
                         [[<sub1 class="B"/>]],
                         [[<sub2 class="A"/>]],
                       })
end

function TestCSSSelect.test_combinator_plus()
  local xml = [[
<root>
  <sub1 class="A">
    <sub2 class="AA"/>
  </sub1>
  <sub2 class="A"/>
  <sub1 class="B"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "sub1 + sub2"),
                       {
                         [[<sub2 class="A"/>]],
                       })
end

function TestCSSSelect.test_combinator_greater()
  local xml = [[
<root>
  <sub1 class="A">
    <sub2 class="AA"/>
    <sub2 class="AB"/>
    <sub2 class="AC"/>
    <sub3 class="AX">
      <sub2 class="AXA"/>
    </sub3>
  </sub1>
  <sub2 class="A"/>
  <sub1 class="B"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "sub1 > sub2"),
                       {
                         [[<sub2 class="AA"/>]],
                         [[<sub2 class="AB"/>]],
                         [[<sub2 class="AC"/>]],
                       })
end

function TestCSSSelect.test_combinator_tilda()
  local xml = [[
<root>
  <sub1 class="A">
    <sub2 class="AA"/>
    <sub2 class="AB"/>
    <sub3 class="AX">
      <sub2 class="AXA"/>
    </sub3>
  </sub1>
  <sub2 class="A"/>
  <sub1 class="B"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "sub1 sub2"),
                       {
                         [[<sub2 class="AA"/>]],
                         [[<sub2 class="AB"/>]],
                         [[<sub2 class="AXA"/>]],
                       })
end

function TestCSSSelect.test_combinator_whitespace()
  local xml = [[
<root>
  <sub1 class="A">
    <sub2 class="AA"/>
    <sub2 class="AB"/>
  </sub1>
  <sub2 class="A"/>
  <sub2 class="B"/>
  <sub1 class="B"/>
</root>
]]
  luaunit.assertEquals(css_select(xml, "sub1 ~ sub2"),
                       {
                         [[<sub2 class="A"/>]],
                         [[<sub2 class="B"/>]],
                       })
end
