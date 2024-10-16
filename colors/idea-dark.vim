set background=dark
let g:colors_name="idea-dark"

lua package.loaded['fengwk.core.colorscheme.idea-dark'] = nil

lua require('lush')(require('fengwk.core.colorscheme.idea-dark'))
