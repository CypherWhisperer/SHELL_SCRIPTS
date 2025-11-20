#!/bin/bash

# React.dev Learn Section Complete Downloader
# This script uses Monolith to download all pages from react.dev/learn for offline access

# Check if monolith is installed
if ! command -v monolith &> /dev/null; then
    echo "❌ Monolith is not installed. Install it with: cargo install monolith"
    exit 1
fi

# Create output directory
OUTPUT_DIR="react-learn-offline"
mkdir -p "$OUTPUT_DIR"

echo "Starting React.dev Learn section download..."
echo "Files will be saved to: $OUTPUT_DIR/"

# Common monolith flags for React.dev
MONOLITH_FLAGS="--isolate --no-frames" # consider --quiet for less verbosity

# Array of URLs to download with their output filenames
declare -A pages=(
    # Main Learn Section
    ["https://react.dev/learn"]="01-quick-start.html"
    
    # Installation & Setup
    ["https://react.dev/learn/installation"]="02-installation.html"
    ["https://react.dev/learn/start-a-new-react-project"]="03-start-new-project.html"
    ["https://react.dev/learn/add-react-to-an-existing-project"]="04-add-react-existing.html"
    ["https://react.dev/learn/editor-setup"]="05-editor-setup.html"
    ["https://react.dev/learn/react-developer-tools"]="06-developer-tools.html"
    ["https://react.dev/learn/typescript"]="07-typescript.html"
    
    # Tutorial
    ["https://react.dev/learn/tutorial-tic-tac-toe"]="08-tutorial-tic-tac-toe.html"
    
    # Describing the UI
    ["https://react.dev/learn/describing-the-ui"]="09-describing-ui.html"
    ["https://react.dev/learn/your-first-component"]="10-first-component.html"
    ["https://react.dev/learn/importing-and-exporting-components"]="11-importing-exporting.html"
    ["https://react.dev/learn/writing-markup-with-jsx"]="12-jsx-markup.html"
    ["https://react.dev/learn/javascript-in-jsx-with-curly-braces"]="13-javascript-in-jsx.html"
    ["https://react.dev/learn/passing-props-to-a-component"]="14-passing-props.html"
    ["https://react.dev/learn/conditional-rendering"]="15-conditional-rendering.html"
    ["https://react.dev/learn/rendering-lists"]="16-rendering-lists.html"
    ["https://react.dev/learn/keeping-components-pure"]="17-pure-components.html"
    ["https://react.dev/learn/understanding-your-ui-as-a-tree"]="18-ui-as-tree.html"
    
    # Adding Interactivity
    ["https://react.dev/learn/adding-interactivity"]="19-adding-interactivity.html"
    ["https://react.dev/learn/responding-to-events"]="20-responding-events.html"
    ["https://react.dev/learn/state-a-components-memory"]="21-state-memory.html"
    ["https://react.dev/learn/render-and-commit"]="22-render-commit.html"
    ["https://react.dev/learn/state-as-a-snapshot"]="23-state-snapshot.html"
    ["https://react.dev/learn/queueing-a-series-of-state-updates"]="24-queueing-state.html"
    ["https://react.dev/learn/updating-objects-in-state"]="25-updating-objects.html"
    ["https://react.dev/learn/updating-arrays-in-state"]="26-updating-arrays.html"
    
    # Managing State
    ["https://react.dev/learn/managing-state"]="27-managing-state.html"
    ["https://react.dev/learn/reacting-to-input-with-state"]="28-input-state.html"
    ["https://react.dev/learn/choosing-the-state-structure"]="29-state-structure.html"
    ["https://react.dev/learn/sharing-state-between-components"]="30-sharing-state.html"
    ["https://react.dev/learn/preserving-and-resetting-state"]="31-preserving-state.html"
    ["https://react.dev/learn/extracting-state-logic-into-a-reducer"]="32-state-reducer.html"
    ["https://react.dev/learn/passing-data-deeply-with-context"]="33-context.html"
    ["https://react.dev/learn/scaling-up-with-reducer-and-context"]="34-reducer-context.html"
    
    # Escape Hatches
    ["https://react.dev/learn/escape-hatches"]="35-escape-hatches.html"
    ["https://react.dev/learn/referencing-values-with-refs"]="36-refs.html"
    ["https://react.dev/learn/manipulating-the-dom-with-refs"]="37-dom-refs.html"
    ["https://react.dev/learn/synchronizing-with-effects"]="38-effects.html"
    ["https://react.dev/learn/you-might-not-need-an-effect"]="39-might-not-need-effect.html"
    ["https://react.dev/learn/lifecycle-of-reactive-effects"]="40-effect-lifecycle.html"
    ["https://react.dev/learn/separating-events-from-effects"]="41-events-effects.html"
    ["https://react.dev/learn/removing-effect-dependencies"]="42-effect-dependencies.html"
    ["https://react.dev/learn/reusing-logic-with-custom-hooks"]="43-custom-hooks.html"
    
    # Thinking in React
    ["https://react.dev/learn/thinking-in-react"]="44-thinking-in-react.html"
)

# Function to download a single page
download_page() {
    local url=$1
    local filename=$2
    local output_path="$OUTPUT_DIR/$filename"
    
    echo "Downloading: $(basename "$filename" .html)"
    
    if monolith $MONOLITH_FLAGS "$url" -o "$output_path" 2>/dev/null; then
        echo "✅ Success: $filename"
    else
        echo "❌ Failed: $filename"
        return 1
    fi
}

# Download all pages
total_pages=${#pages[@]}
current=0
failed=0

for url in "${!pages[@]}"; do
    current=$((current + 1))
    filename="${pages[$url]}"
    
    echo ""
    echo "[$current/$total_pages] Processing..."
    
    if ! download_page "$url" "$filename"; then
        failed=$((failed + 1))
    fi
    
    # Small delay to be respectful to the server
    sleep 1
done

# Create an index page
echo ""
echo "Creating index page..."

cat > "$OUTPUT_DIR/index.html" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>React.dev Learn - Offline</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; }
        h1 { color: #61dafb; }
        .section { margin: 30px 0; }
        .section h2 { color: #333; border-bottom: 2px solid #61dafb; padding-bottom: 5px; }
        ul { list-style: none; padding: 0; }
        li { margin: 8px 0; }
        a { color: #0066cc; text-decoration: none; padding: 4px 8px; display: block; border-radius: 4px; transition: background 0.2s; }
        a:hover { background: #f0f8ff; }
        .note { background: #f8f9fa; padding: 15px; border-left: 4px solid #61dafb; margin: 20px 0; }
    </style>
</head>
<body>
    <h1>⚛️ React.dev Learn Section - Offline</h1>
    
    <div class="note">
        <strong>Note:</strong> These are offline copies of the React.dev documentation. 
        Some interactive features may not work, but all the content is preserved.
    </div>

    <div class="section">
        <h2>Getting Started</h2>
        <ul>
            <li><a href="01-quick-start.html">Quick Start</a></li>
            <li><a href="02-installation.html">Installation</a></li>
            <li><a href="03-start-new-project.html">Start a New React Project</a></li>
            <li><a href="04-add-react-existing.html">Add React to Existing Project</a></li>
            <li><a href="05-editor-setup.html">Editor Setup</a></li>
            <li><a href="06-developer-tools.html">React Developer Tools</a></li>
            <li><a href="07-typescript.html">Using TypeScript</a></li>
        </ul>
    </div>

    <div class="section">
        <h2>Tutorial</h2>
        <ul>
            <li><a href="08-tutorial-tic-tac-toe.html">Tutorial: Tic-Tac-Toe</a></li>
        </ul>
    </div>

    <div class="section">
        <h2>Describing the UI</h2>
        <ul>
            <li><a href="09-describing-ui.html">Describing the UI</a></li>
            <li><a href="10-first-component.html">Your First Component</a></li>
            <li><a href="11-importing-exporting.html">Importing and Exporting Components</a></li>
            <li><a href="12-jsx-markup.html">Writing Markup with JSX</a></li>
            <li><a href="13-javascript-in-jsx.html">JavaScript in JSX with Curly Braces</a></li>
            <li><a href="14-passing-props.html">Passing Props to a Component</a></li>
            <li><a href="15-conditional-rendering.html">Conditional Rendering</a></li>
            <li><a href="16-rendering-lists.html">Rendering Lists</a></li>
            <li><a href="17-pure-components.html">Keeping Components Pure</a></li>
            <li><a href="18-ui-as-tree.html">Understanding Your UI as a Tree</a></li>
        </ul>
    </div>

    <div class="section">
        <h2>Adding Interactivity</h2>
        <ul>
            <li><a href="19-adding-interactivity.html">Adding Interactivity</a></li>
            <li><a href="20-responding-events.html">Responding to Events</a></li>
            <li><a href="21-state-memory.html">State: A Component's Memory</a></li>
            <li><a href="22-render-commit.html">Render and Commit</a></li>
            <li><a href="23-state-snapshot.html">State as a Snapshot</a></li>
            <li><a href="24-queueing-state.html">Queueing a Series of State Updates</a></li>
            <li><a href="25-updating-objects.html">Updating Objects in State</a></li>
            <li><a href="26-updating-arrays.html">Updating Arrays in State</a></li>
        </ul>
    </div>

    <div class="section">
        <h2>Managing State</h2>
        <ul>
            <li><a href="27-managing-state.html">Managing State</a></li>
            <li><a href="28-input-state.html">Reacting to Input with State</a></li>
            <li><a href="29-state-structure.html">Choosing the State Structure</a></li>
            <li><a href="30-sharing-state.html">Sharing State Between Components</a></li>
            <li><a href="31-preserving-state.html">Preserving and Resetting State</a></li>
            <li><a href="32-state-reducer.html">Extracting State Logic into a Reducer</a></li>
            <li><a href="33-context.html">Passing Data Deeply with Context</a></li>
            <li><a href="34-reducer-context.html">Scaling Up with Reducer and Context</a></li>
        </ul>
    </div>

    <div class="section">
        <h2>Escape Hatches</h2>
        <ul>
            <li><a href="35-escape-hatches.html">Escape Hatches</a></li>
            <li><a href="36-refs.html">Referencing Values with Refs</a></li>
            <li><a href="37-dom-refs.html">Manipulating the DOM with Refs</a></li>
            <li><a href="38-effects.html">Synchronizing with Effects</a></li>
            <li><a href="39-might-not-need-effect.html">You Might Not Need an Effect</a></li>
            <li><a href="40-effect-lifecycle.html">Lifecycle of Reactive Effects</a></li>
            <li><a href="41-events-effects.html">Separating Events from Effects</a></li>
            <li><a href="42-effect-dependencies.html">Removing Effect Dependencies</a></li>
            <li><a href="43-custom-hooks.html">Reusing Logic with Custom Hooks</a></li>
        </ul>
    </div>

    <div class="section">
        <h2>Advanced</h2>
        <ul>
            <li><a href="44-thinking-in-react.html">Thinking in React</a></li>
        </ul>
    </div>
</body>
</html>
EOF

echo "✅ Index page created: $OUTPUT_DIR/index.html"

# Summary
echo ""
echo "Download complete!"
echo "Summary:"
echo "   • Total pages: $total_pages"
echo "   • Failed: $failed"
echo "   • Successful: $((total_pages - failed))"
echo ""
echo "All files saved to: $OUTPUT_DIR/"
echo "Open $OUTPUT_DIR/index.html in your browser to start learning!"

if [ $failed -gt 0 ]; then
    echo ""
    echo "⚠️  Some downloads failed. You can re-run this script to retry failed downloads."
fi
