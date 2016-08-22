#!/usr/bin/env python
# coding: utf8

from win32com.client import DispatchEx, constants, gencache

def doc2pdf(input, output):
    app = DispatchEx("Word.Application")
    #app.Visible = 0
    #app.DisplayAlerts = 0
    try:
        doc = app.Documents.Open(input, ReadOnly = 1)
        #doc.ExportAsFixedFormat(output, constants.wdExportFormatPDF, Item=constants.wdExportDocumentWithMarkup, CreateBookmarks=constants.wdExportCreateHeadingBookmarks)
        doc.SaveAs(output, FileFormat=17)
        doc.Close(constants.wdDoNotSaveChanges)
        return 0
    except Exception, e:
        print e
        return 1
    finally:
        app.Quit()
        
# Generate all the support        
def GenerateSupport():
    gencache.EnsureModule('{00020905-0000-0000-C000-000000000046}', 0, 8, 4)        
        

GenerateSupport()
finput  = u"d:\\wspace\\docs\\云系统设计.docx"
foutput = u"d:\\wspace\\docs\\test.pdf"
doc2pdf(finput, foutput)

