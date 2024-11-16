from flask import Flask, request, send_file, jsonify
import subprocess
import tempfile
import os

app = Flask(__name__)

def create_dylib(lua_code):
    try:
        # Create a temporary directory to store the dylib files
        temp_dir = tempfile.mkdtemp()
        dylib_path = os.path.join(temp_dir, "generated.dylib")
        
        # Compile the Lua code to dylib (dummy example)
        # Here you would have your logic to convert Lua to dylib
        with open(os.path.join(temp_dir, "temp.lua"), "w") as f:
            f.write(lua_code)
        
        # For the purpose of this example, we are just creating a dummy .dylib
        subprocess.run(['clang', '-shared', '-o', dylib_path, os.path.join(temp_dir, "temp.lua")], check=True)
        
        # Sign the dylib (use your actual signing method)
        subprocess.run(['codesign', '--sign', 'Developer ID Application: YourName (XXXXXXXXXX)', dylib_path], check=True)

        return dylib_path
    except Exception as e:
        print(f"Error: {e}")
        return None

@app.route('/generate_dylib', methods=['POST'])
def generate_dylib():
    data = request.get_json()
    lua_code = data.get('lua_code')

    if not lua_code:
        return jsonify({"error": "Lua code is required"}), 400

    dylib_path = create_dylib(lua_code)

    if dylib_path:
        return send_file(dylib_path, as_attachment=True)
    else:
        return jsonify({"error": "Failed to generate .dylib"}), 500

if __name__ == "__main__":
    app.run(debug=True)
