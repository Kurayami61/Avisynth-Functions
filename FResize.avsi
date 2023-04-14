
###################################################################################################
##                                           FResize                                             ##
##                                        V1 By Kurayami                                         ##
##                                        15 April 2023                                          ##
###################################################################################################







function FResize(clip input, int "owidth", int "oheight", string "imatrix", string "omatrix", \
                           string "cshift", string "oColorspace", \
                           float "b", float "c", int "taps", float "p", bool "debug") {


input
Assert(input.Isplanar(), "FResize only accepts planar input, convert to a planar colorspace")


############################################################################################
##                                                                                        ##
##                                   Defaults                                             ##
##                                                                                        ##
############################################################################################


owidth = Default(owidth, input.Width())
oheight = Default(oheight, input.Height())
cshift = Default(cshift, "Spline36")
ocolorspace = Default(ocolorspace, "YV12")
b = Default(b, 1/3)
c = Default(c, 1/3)
taps = Default(taps,3)
debug = Default(debug,false)


############################################################################################
##                                                                                        ##
##                                   input_matrix                                         ##
##                                                                                        ##
############################################################################################


imatrix = height(input) <720 ? "rec601" :\
               2160 > height(input) >= 720 ? "rec709" :\
               "rec2020"

############################################################################################
############################################################################################
############################################################################################
############################################################################################
############################################################################################


input = input.converttorgb32(matrix=imatrix)


############################################################################################
##                                                                                        ##
##                                        Resizer                                         ##
##                                                                                        ##
############################################################################################


R1 = "Resize(" + string(owidth) + ", " + string(oheight) + ")"
R2 = "Resize(" + string(owidth) + ", " + string(oheight) + ", b=" string(b) +", c=" string(c) + ")"
R3 = "Resize(" + string(owidth) + ", " + string(oheight) + ", taps=" + String(taps) + ")"
R4 = "Resize(" + string(owidth) + ", " + string(oheight) + ", p=" + string(p) + ")"


resizer =\
(cshift == "bilinear") ? cshift + R1 :\
(cshift == "bicubic") ? cshift + R2 :\
(cshift == "Blackman") ? cshift + R3 :\
(cshift == "Gauss") ?  cshift + R4 :\
(cshift == "Lanczos") ? cshift + R3 :\
(cshift == "Lanczos4") ? cshift + R1 :\
(cshift == "Point") ? cshift + R1 :\
(cshift == "Sinc") ? cshift + R3 :\
(cshift == "Spline16") ? cshift + R1 :\
(cshift == "Spline36") ? cshift + R1 :\
(cshift == "Spline64") ? cshift + R1 :\
Assert(false, "invalid resize method")


output = last
output = Eval(resizer)
output



############################################################################################
##                                                                                        ##
##                                  output_matrix                                         ##
##                                                                                        ##
############################################################################################


omatrix = height(output) <720 ? "rec601" :\
               2160 > height(output) >= 720 ? "rec709" :\
               "rec2020"


############################################################################################
############################################################################################
############################################################################################
############################################################################################
############################################################################################

ocs = "Convertto" + ocolorspace + "(matrix="  + Chr(34) + omatrix + chr(34) + ")"

output = eval(ocs)
output

debug ? output.Subtitle(string(ocs),size=height(output)/14).\
            Subtitle(string(resizer), y = (Height(output)/14 + height(output)/32), size=Height(output)/14)\
            : output
            
return last

}
