####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################
##                                          CHANGELOG                                           ##
####################################################################################################
####################################################################################################
####################################################################################################
####################################################################################################


# 1.4 changes:

    # NEW
        # ThreeComp added
            # Compares three video streams
            # Available modes: -1, -2, -3, 1, 2, 3

        # Comparison changes:
            # New mode at mode 2/-2:
                                        # Vertical counterpart to mode 1/-1
            # Added negative modes (flipped versions of the positive counterparts)
            # Previous mode 2 moved to mode 3
            # Previous mode 3 moved to mode 4
            # Removed forced converttoyv12
            # Adjusted Boolean statements
            # Function name changed from "comparison" to "Comparison"

        # FourComp changes:
            # Function name change from "fourcomp" to "FourComp"
            # Code spacing and capitalization fixed



function Comparison(clip "clp", clip "clp2", int "mode", int "slide", int "color", string "input", string "output") {

###################################################################################################
##                                          Comparison                                           ##
##                                       V1.4 By Kurayami                                        ##
##                                       January 03 2022                                         ##
##                           Last updated: February 07 2024                           ##
###################################################################################################


bitscheck = clp.BitsPerComponent() > 8 ? clp.convertto8bit : clp 
bitscheck2 = clp2.BitsPerComponent() > 8 ? clp.convertto8bit : clp2 

mode = Default(mode, 1)
color = Default(color, $FFFFFF)
input = Default(input, "input")
output = Default(output, "output")

slide = (mode == 4 || mode == -4) ? Default(slide, Height(clp)/2) : Default(slide, width(clp)/2)

clp = clp.converttorgb32
clp2 = clp2.converttorgb32

compare = \
                  (mode == 1) ? StackHorizontal(clp.Subtitle(input, size=clp.Height()/15), clp2.Subtitle(output, size=clp2.Height()/15))   :\
                                       \
                  (mode == -1) ? StackHorizontal(clp2.Subtitle(output, size=clp2.Height()/15), clp.Subtitle(input, size=clp.Height()/15))    :\
                                       \
                  (mode == 2) ? StackVertical(clp.Subtitle(input, size=clp.Height()/15), clp2.Subtitle(output, size=clp2.Height()/15))        :\
                                       \
                  (mode == -2) ? StackVertical(clp2.Subtitle(output, size=clp2.Height()/15), clp.Subtitle(input, size=clp.Height()/15))         :\
                                       \
                  (mode == 3) ? StackHorizontal(StackHorizontal(clp.Subtitle(input, size=clp.Height()/15).crop(0,0,-clp.width()+slide,0), \
                                                                                               BlankClip(clp, color=color).crop(0,0,-clp.width()+2,0)),                           \
                                                                    clp2.crop(slide+2,0,0,0).Subtitle(output, size=clp2.Height()/15))                                       :\
                                       \
                  (mode == -3) ? StackHorizontal(StackHorizontal(clp2.Subtitle(output, size=clp2.Height()/15).crop(0,0,-clp2.width()+slide,0), \
                                                                                                 BlankClip(clp2, color=color).crop(0,0,-clp2.width()+2,0)),                            \
                                                                     clp.crop(slide+2,0,0,0).Subtitle(input, size=clp.Height()/15))                                                   :\
                                         \
                  (mode == 4) ? StackVertical(StackVertical(clp.Subtitle(input, size=clp.Height()/15).crop(0,0,0,-clp.height()+slide), \
                                                                                       BlankClip(clp, color=color).crop(0,0,0,-clp.height()+2)),                          \
                                                                clp2.crop(0,slide + 2,0,0).Subtitle(output, size=clp2.Height()/15)) :\
                                         \
                  (mode == -4) ? StackVertical(StackVertical(clp2.Subtitle(output, size=clp2.Height()/15).crop(0,0,0,-clp2.height()+slide), \
                                                                                        BlankClip(clp2, color=color).crop(0,0,0,-clp2.height()+2)),                              \
                                                                 clp.crop(0,slide + 2,0,0).Subtitle(input, size=clp.Height()/15))                                              :\
                                         \
                  Assert(false, "no more modes are available")

return compare

}




function ThreeComp(clip a, clip b, clip c, string "clip1", string "clip2", string "clip3", int "mode") {

###################################################################################################
##                                           ThreeComp                                            ##
##                                        V1 By Kurayami                                         ##
##                                      February 07 2024                                        ##
###################################################################################################

clip1 = Default(clip1, "clip1")
clip2 = Default(clip2, "clip2")
clip3 = Default(clip3, "clip3")
mode = Default(mode, 1)

a = a.Subtitle(clip1, size=a.Height()/16)
b = b.Subtitle(clip2, size=b.Height()/16)
c = c.Subtitle(clip3, size=c.Height()/16)



compare = \
                   (mode == 1) ? StackHorizontal(a.AddBorders(0, (b.Height() + c.Height() - a.Height())/2, 0, (b.Height() + c.Height() - a.Height())/2), \
                                                                    StackVertical(b,c)) :\
                   (mode == -1) ? StackHorizontal(StackVertical(b,c),\
                                                                     a.AddBorders(0, (b.Height() + c.Height() - a.Height())/2, 0, (b.Height() + c.Height() - a.Height())/2)) :\
                   (mode == 2) ? StackHorizontal(b.AddBorders(0, (a.Height() + c.Height() - b.Height())/2, 0, (a.Height() + c.Height() - b.Height())/2), \
                                                                     StackVertical(a,c)) :\
                   (mode == -2) ? StackHorizontal(StackVertical(a,c), \
                                                                      b.AddBorders(0, (a.Height() + c.Height() - b.Height())/2, 0, (a.Height() + c.Height() - b.Height())/2)) :\
                   (mode == 3) ? StackHorizontal(c.AddBorders(0, (b.Height() + a.Height() - c.Height())/2, 0, (b.Height() + a.Height() - c.Height())/2), \
                                                                     StackVertical(a,b)) :\
                   (mode == -3) ? StackHorizontal(StackVertical(a,b), \
                                                                      c.AddBorders(0, (b.Height() + a.Height() - c.Height())/2, 0, (b.Height() + a.Height() - c.Height())/2)) :\
                   Assert(false, "no more modes are available")

return compare         

}




function FourComp(clip a, clip b, clip c, clip d, string "clip1", string "clip2", string "clip3", string "clip4") {


###################################################################################################
##                                           FourComp                                            ##
##                                        V1 By Kurayami                                         ##
##                                       January 03 2022                                         ##
##                             Updated: February 07 2024                             ##
###################################################################################################


clip1 = Default(clip1, "clip1")
clip2 = Default(clip2, "clip2")
clip3 = Default(clip3, "clip3")
clip4 = Default(clip4, "clip4")

a = a.Subtitle(clip1, size=a.Height()/16)
b = b.Subtitle(clip2, size=a.Height()/16)
c = c.Subtitle(clip3, size=a.Height()/16)
d = d.Subtitle(clip4, size=a.Height()/16)

stack1 = StackHorizontal(a,b)
stack2 = StackHorizontal(c,d)
StackVertical(stack1,stack2)


}