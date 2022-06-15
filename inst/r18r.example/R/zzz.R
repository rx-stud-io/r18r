.onLoad <- function(libname, pkgname) {
    r18r::translations_import(r18r::po_folder(pkgname), pkgname)
    r18r::translate_set_language('hu', pkgname)
}
