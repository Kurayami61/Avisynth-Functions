function EC_replace(clip episode, clip ec, int "pAend", int "pBstart", bool "ecComp") {

###################################################################################################
##                                           EC_Replace                                          ##
##                                         V1 By Kurayami                                        ##
##                                          April 22 2023                                        ##
###################################################################################################

eccomp = default(eccomp,false)

PA = episode.trim(0,pAend)
PB = episode.trim(pBstart,0)
ogEC = episode.trim(pAend+1, pBstart-1)


final = PA ++ ec ++ PB

ecstack = StackHorizontal(ogEC.Subtitle("original eyecatch", size=episode.Height()/16), ec.Subtitle("imported eyecatch", size=ec.Height()/16))

ecComp ? ecstack : final


check = (framecount(final) == framecount(episode)) ? final : ecstack

return check

}
