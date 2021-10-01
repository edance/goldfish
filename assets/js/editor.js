const editor = document.getElementById("editor");

if (editor && EasyMDE) {
  new EasyMDE({ element: editor });
}
