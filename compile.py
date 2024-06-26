# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'compile.ui'
#
# Created by: PyQt5 UI code generator 5.15.10
#
# WARNING: Any manual changes made to this file will be lost when pyuic5 is
# run again.  Do not edit this file unless you know what you are doing.


import subprocess
from PyQt5 import QtCore, QtGui, QtWidgets
import sys
from PyQt5.QtWidgets import QApplication, QDialog, QLabel, QPushButton, QVBoxLayout
from PyQt5 import QtCore


class Ui_Dialog(object):
    def setupUi(self, Dialog):
        Dialog.setObjectName("Dialog")
        Dialog.resize(800, 620)
        self.gridLayout_3 = QtWidgets.QGridLayout(Dialog)
        self.gridLayout_3.setObjectName("gridLayout_3")
        self.gridLayout = QtWidgets.QGridLayout()
        self.gridLayout.setObjectName("gridLayout")
        self.horizontalLayout_2 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_2.setObjectName("horizontalLayout_2")
        self.verticalLayout_2 = QtWidgets.QVBoxLayout()
        self.verticalLayout_2.setObjectName("verticalLayout_2")
        self.label = QtWidgets.QLabel(Dialog)
        self.label.setObjectName("label")
        self.verticalLayout_2.addWidget(self.label)
        self.code_text = QtWidgets.QTextEdit(Dialog)
        self.code_text.setObjectName("code_text")
        self.verticalLayout_2.addWidget(self.code_text)
        self.horizontalLayout_2.addLayout(self.verticalLayout_2)
        self.verticalLayout_3 = QtWidgets.QVBoxLayout()
        self.verticalLayout_3.setObjectName("verticalLayout_3")
        self.label_2 = QtWidgets.QLabel(Dialog)
        self.label_2.setObjectName("label_2")
        self.verticalLayout_3.addWidget(self.label_2)
        self.result_text = QtWidgets.QTextEdit(Dialog)
        self.result_text.setObjectName("result_text")
        self.verticalLayout_3.addWidget(self.result_text)
        self.horizontalLayout_2.addLayout(self.verticalLayout_3)
        self.gridLayout.addLayout(self.horizontalLayout_2, 0, 0, 1, 1)
        self.gridLayout_2 = QtWidgets.QGridLayout()
        self.gridLayout_2.setObjectName("gridLayout_2")
        self.Compile_btn = QtWidgets.QPushButton(Dialog)
        self.Compile_btn.setObjectName("Compile_btn")
        self.gridLayout_2.addWidget(self.Compile_btn, 0, 0, 1, 1)
        self.close_btn = QtWidgets.QPushButton(Dialog)
        self.close_btn.setObjectName("close_btn")
        self.gridLayout_2.addWidget(self.close_btn, 0, 1, 1, 1)
        self.gridLayout.addLayout(self.gridLayout_2, 1, 0, 1, 1)
        self.gridLayout_3.addLayout(self.gridLayout, 0, 0, 1, 1)

        self.retranslateUi(Dialog)
        QtCore.QMetaObject.connectSlotsByName(Dialog)

    def retranslateUi(self, Dialog):
        _translate = QtCore.QCoreApplication.translate
        Dialog.setWindowTitle(_translate("Dialog", "Dialog"))
        self.label.setText(_translate("Dialog", "Code"))
        self.label_2.setText(_translate("Dialog", "Result"))
        self.Compile_btn.setText(_translate("Dialog", "Compile"))
        self.close_btn.setText(_translate("Dialog", "Close"))
        self.result_text
        self.code_text

class MyDialog(QDialog, Ui_Dialog):
    def __init__(self):
        super().__init__()
        self.setupUi(self)
        self.Compile_btn.clicked.connect(self.compile_button_clicked)
        self.close_btn.clicked.connect(self.close)

    def compile_button_clicked(self):
        # Define the action to be performed when Compile_btn is clicked
        try:
            # Extract text from the QLabel
            code = self.code_text.toPlainText()
            # Write the text to input.txt
            with open("input.txt", "w") as file:
                file.write(code)

            # Clear the output file
            with open("output.txt", "w") as file:
                pass  # This will clear the file

            # Run the compiler.exe command with input.txt as an argument
            subprocess.run(["./compiler.exe", "input.txt"])

            # Read the result from output.txt and display it in label_2
            res = ""
            res += "Output:\n"
            with open("output.txt", "r") as file:
                result_text = file.read()
                res += result_text
                # self.result_text.setText(result_text)
            
            res += "\n\nErrors:\n"
            with open("errors.txt", "r") as file:
                result_text = file.read()
                res += result_text
                # self.result_text.setText(result_text)
                
            res += "\n\nSymbol Table:\n"
            with open("symbol_table.txt", "r") as file:
                result_text = file.read()
                res += result_text
            
            self.result_text.setText(res)
        except FileNotFoundError:
            print("Error: compiler.exe or output.txt not found!")


if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    Dialog = QtWidgets.QDialog()
    ui = Ui_Dialog()
    ui.setupUi(Dialog)
    Dialog.show()

    compileDialog = MyDialog()
    compileDialog.show()
    
    sys.exit(app.exec_())
