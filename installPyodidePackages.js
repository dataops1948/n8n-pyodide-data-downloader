import fs from "fs";
import { loadPyodide } from "pyodide";

const pyodide = await loadPyodide();
await pyodide.loadPackage("micropip");

const micropip = pyodide.pyimport("micropip");

let requirementsTxt = fs.readFileSync("./pyodide.requirements.txt", {
  encoding: "utf-8",
});
requirementsTxt = requirementsTxt.trim();

const requirements = requirementsTxt
  .split("\n")
  .map((requirement) => requirement.trim())
  .filter(Boolean);

for (let requirement of requirements) {
  console.log(`Installing ${requirement}...`);
  await micropip.install(requirement.trim());
  console.log(`${requirement} installed successfully.`);
}
