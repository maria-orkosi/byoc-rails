# Initialize seed data for component library demo

puts "Seeding components..."

components = [
  { name: "Button", description: "A versatile button component with multiple variants including primary, secondary, outline, and ghost styles. Supports icons, loading states, and disabled mode.", preview_url: nil, version: "2.1.0", compatibility: "Rails 7+", dependencies: ["tailwindcss", "view_component"] },
  { name: "Modal", description: "A responsive modal dialog with backdrop overlay, focus trap, and keyboard navigation. Supports custom headers, footers, and animated transitions.", preview_url: nil, version: "1.5.3", compatibility: "Rails 7+", dependencies: ["stimulus", "tailwindcss"] },
  { name: "DataTable", description: "A feature-rich data table with sorting, filtering, pagination, and row selection. Supports server-side and client-side data processing.", preview_url: nil, version: "3.0.1", compatibility: "Rails 7+", dependencies: ["turbo", "stimulus"] },
  { name: "FormBuilder", description: "A form builder that generates accessible, validated forms with inline error messages. Supports nested attributes and dynamic field addition.", preview_url: nil, version: "2.3.0", compatibility: "Rails 7+", dependencies: ["simple_form"] },
  { name: "Navbar", description: "A responsive navigation bar with dropdown menus, mobile hamburger toggle, and active state highlighting. Customizable brand and link sections.", preview_url: nil, version: "1.8.0", compatibility: "Rails 7+", dependencies: ["tailwindcss"] },
  { name: "Card", description: "A flexible card component for displaying grouped content with optional header, footer, image, and action areas.", preview_url: nil, version: "2.0.2", compatibility: "Rails 7+", dependencies: ["tailwindcss"] },
  { name: "Alert", description: "Contextual alert messages for success, error, warning, and info states. Supports dismissible and auto-hide behaviors.", preview_url: nil, version: "1.2.0", compatibility: "Rails 7+", dependencies: [] },
  { name: "Pagination", description: "A pagination component that works with Kaminari or WillPaginate. Renders page links, previous/next, and gap indicators.", preview_url: nil, version: "1.4.1", compatibility: "Rails 7+", dependencies: ["kaminari"] },
  { name: "Tabs", description: "A tabbed interface component for organizing content into panes. Supports horizontal and vertical orientations with animated transitions.", preview_url: nil, version: "2.0.0", compatibility: "Rails 7+", dependencies: ["stimulus"] },
  { name: "SearchInput", description: "An autocomplete search input with debounced queries, result highlighting, and keyboard navigation through suggestions.", preview_url: nil, version: "1.6.2", compatibility: "Rails 7+", dependencies: ["stimulus", "turbo"] },
  { name: "Breadcrumbs", description: "A breadcrumb navigation component that automatically generates from the current route hierarchy with schema.org markup.", preview_url: nil, version: "1.0.0", compatibility: "Rails 7+", dependencies: [] },
  { name: "Avatar", description: "An avatar component for displaying user profile images with fallback initials. Supports multiple sizes and grouped avatar stacks.", preview_url: nil, version: "1.1.3", compatibility: "Rails 7+", dependencies: ["tailwindcss"] },
  { name: "Tooltip", description: "A tooltip component that displays contextual help text on hover or focus. Positioned automatically to stay within viewport.", preview_url: nil, version: "1.3.0", compatibility: "Rails 7+", dependencies: [] },
  { name: "ProgressBar", description: "A progress indicator for multi-step processes or loading states. Supports determinate and indeterminate modes.", preview_url: nil, version: "1.0.5", compatibility: "Rails 7+", dependencies: ["tailwindcss"] },
  { name: "DatePicker", description: "A date picker component with calendar popup, range selection, and locale-aware formatting.", preview_url: nil, version: "2.4.0", compatibility: "Rails 7+", dependencies: ["stimulus"] },
]

components.each do |attrs|
  Component.find_or_create_by!(name: attrs[:name]) do |c|
    c.assign_attributes(attrs)
  end
end

puts "Created #{Component.count} components."

puts "Seeding demo project..."
project = Project.find_or_create_by!(name: "My SaaS App") do |p|
  p.description = "A demo project showcasing the component library management system."
end

# Add some components to the demo project
demo_components = Component.limit(5)
demo_components.each_with_index do |comp, idx|
  ProjectComponent.find_or_create_by!(project: project, component: comp) do |pc|
    pc.position = idx
  end
end

# Create a demo group
group = ComponentGroup.find_or_create_by!(project: project, name: "Core UI")

puts "Seeding complete!"