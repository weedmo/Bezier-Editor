# 🎨 Bezier Curve GUI Editor in MATLAB

This project is a MATLAB-based GUI tool that allows users to intuitively edit and visualize Bezier curves.  
Users can interactively modify control points, extract slope (tangent) information from an outer curve at two specified x-coordinates, and automatically generate and adjust an inner Bezier curve.
![image](https://github.com/user-attachments/assets/a9744155-fce0-4047-bbb9-c50f799bf388)

---

## 📌 Overview

- **Purpose:**  
  Provide an easy-to-use editor for Bezier curves in MATLAB, enabling real-time curve editing via GUI controls.

- **Features:**
  - Generate an **outer Bezier curve** using user-defined control points.
  - Extract tangent (slope) at two specific x-positions (`x1`, `x2`) from the outer curve.
  - Automatically generate an **inner Bezier curve** using the extracted slopes.
  - Interactively adjust the inner curve by dragging control points (with some points constrained to move along the tangent).
  - Easily modify curve degree, initial control points, and x-coordinate range through the GUI.

---

## 🛠 How to Use

### 1. Environment Setup
- Save all `.m` files in the same folder.
- Required class files:
  - `BezierEditor.m`
  - `BezierGUI.m`
  - `BezierDrawer.m`
  - `BezierCalculator.m`
  - `BezierControlManager.m`

### 2. Launching the Editor
- Open MATLAB and set the current folder to the project directory.
- In the Command Window, run:
  
      editor = BezierEditor();

- The Bezier Editor GUI window will appear.

### 3. Generating the Outer Curve
- On the left panel, confirm or modify:
  - The degree of the Bezier curve (default: 3)
  - The two x-coordinates (`x1` and `x2`)
- Click the **"Draw Curve"** button to generate the outer curve and display the initial control points on the graph.

### 4. Editing Outer Control Points
- The control point table displays default values (e.g., `[0,0; 1,1; 2,0; 3,1]`).
- Modify any control point values (X, Y) as desired.
- Click the **"Update Control Points"** button to refresh the outer curve based on the new values.

### 5. Interactively Editing the Inner Curve
- After the outer curve is drawn, the inner Bezier curve is generated automatically using the slopes at `x1` and `x2`.
- Drag the inner control points using your mouse to adjust the inner curve in real-time.
  - Note: The second and second-to-last control points are constrained to move along the tangent direction.

### 6. Resetting the Editor
- Click the **"Reset"** button to clear the plot and revert all settings to their default values.

---

## 📐 Class Structure

### **BezierEditor**
- **Role:** Top-level class that initializes the entire editor.
- **Components:**  
  - Creates instances of the Calculator, GUI, and Drawer classes.

### **BezierGUI**
- **Role:** Constructs the GUI window, including figure, axes, control panels (table, buttons), and sets event callbacks.
- **Function:**  
  - Interfaces with the Control Manager to update curves based on user interactions (mouse drag, button clicks).

### **BezierDrawer**
- **Role:** Handles plotting for both outer and inner Bezier curves.
- **Key Methods:**  
  - `drawBezierCurve`: Draws the Bezier curve.
  - `plotPointAndSlope`: Plots control points and tangent vectors.
  - `updateInnerBezier`: Dynamically updates the inner curve.
  - `updateLegend`: Refreshes the plot legend.

### **BezierCalculator**
- **Role:** Performs all Bezier curve calculations.
- **Key Methods:**  
  - `calculateBezierPoints`: Computes curve points for a set of control points and t-values.
  - `findPointAndSlope`: Estimates the y-value and slope at a given x-coordinate on the curve.

### **BezierControlManager**
- **Role:** Manages control points for both outer and inner curves.
- **Function:**  
  - Initializes curves using `initializeCurves`.
  - Implements interactive dragging with `startDrag`, `moveControlPoint`, and `endDrag`.
  - Updates curves upon changes in control points using `updateOuterPoints`, `createInnerCurve`, and `updateInnerCurve`.
  - Enforces slope constraints via `constrainControlPoint`.

---

## 🌀 How It Works

1. **Initialization:**  
   Running `BezierEditor` instantiates the GUI, Calculator, and Drawer components.
2. **Curve Generation:**  
   Upon clicking "Draw Curve", the editor generates the outer Bezier curve based on the specified degree and x-coordinate range.  
   The slopes at `x1` and `x2` are computed and used to automatically generate the inner Bezier curve.
3. **Interactive Editing:**  
   Users can drag inner control points to refine the curve.  
   Updates in the control point table trigger a recalculation of the outer curve.
4. **Reset:**  
   The reset function reverts all settings and clears the current plots.

---

## 👤 Author

- **Joonmo Han (한준모)**
- Mechanical Engineering, Dankook University  

---

## 🏁 Notes

- This project was developed as a university assignment to provide an intuitive MATLAB GUI for editing Bezier curves.
- It serves as a learning tool for understanding curve modeling, GUI design, and real-time geometry manipulation.

