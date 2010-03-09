// -------------------------------------------------------------------
// markItUp!
// -------------------------------------------------------------------
// Copyright (C) 2008 Jay Salvat
// http://markitup.jaysalvat.com/
// -------------------------------------------------------------------
// Textile tags example
// http://en.wikipedia.org/wiki/Textile_(markup_language)
// http://www.textism.com/
// -------------------------------------------------------------------
// Feel free to add more tags
// -------------------------------------------------------------------
markItUpTextileSettings = {
  previewParserPath:  '/vendor/markitup/templates/preview.html', // path to your Textile parser
  onShiftEnter:    {keepDefault:false, replaceWith:'\n\n'},
  markupSet: [
    {name:'Überschrift 1', key:'1', openWith:'h1(!(([![Class]!]))!). ', placeHolder:'Überschrift hier...' },
    {name:'Überschrift 2', key:'2', openWith:'h2(!(([![Class]!]))!). ', placeHolder:'Überschrift hier...' },
    {name:'Überschrift 3', key:'3', openWith:'h3(!(([![Class]!]))!). ', placeHolder:'Überschrift hier...' },
//    {name:'Heading 4', key:'4', openWith:'h4(!(([![Class]!]))!). ', placeHolder:'Your title here...' },
//    {name:'Heading 5', key:'5', openWith:'h5(!(([![Class]!]))!). ', placeHolder:'Your title here...' },
//    {name:'Heading 6', key:'6', openWith:'h6(!(([![Class]!]))!). ', placeHolder:'Your title here...' },
    {name:'Paragraph', key:'P', openWith:'p(!(([![Class]!]))!). '},
    {separator:'---------------' },
    {name:'Fett', key:'B', closeWith:'*', openWith:'*'},
    {name:'Kursiv', key:'I', closeWith:'_', openWith:'_'},
    {name:'Durchgestrichen', key:'S', closeWith:'-', openWith:'-'},
    {separator:'---------------' },
    {name:'Aufzählung (Punkte)', openWith:'(!(* |!|*)!)'},
    {name:'Aufzählung (Numerisch)', openWith:'(!(# |!|#)!)'},
    {separator:'---------------' },
//    {name:'Picture', replaceWith:'![![Source:!:http://]!]([![Alternative text]!])!'},
    {name:'Link', openWith:'"', closeWith:'([![Title]!])":[![Link:!:http://]!]', placeHolder:'Linktext hier...' },
    {separator:'---------------' },
    {name:'Zitat', openWith:'bq(!(([![Class]!]))!). '},
    {name:'Code (Inline)', openWith:'@', closeWith:'@'},
    {name:'Code (Block)', openWith:'bc(!(([![Class]!]))!). '},
//    {separator:'---------------' },
//    {name:'Preview', call:'preview', className:'preview'}
  ]
}