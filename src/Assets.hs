module Assets where


import System.IO.Unsafe (unsafePerformIO)
import qualified Data.ByteString as B
import qualified Data.ByteString.Builder as B
import Data.ByteString.Lazy (toStrict)


-- Automatically generated
-- This file contains all assets, loaded via 'unsafePerformIO' or hardcoded as string, not to need IO for assets


allAssets = [("White.style", _White_style)
			, ("WhiteFlat.style", _WhiteFlat_style)
			, ("language-changes.lang", _language_changes_lang)
			, ("Style.language", _Style_language)
			, ("Terminal.style", _Terminal_style)
			, ("language.lang", _language_lang)
			, ("Manual/TypeTrees1.svg", _Manual_TypeTrees1_svg)
			, ("Manual/2.0Tut-Intro.md", _Manual_2_0Tut_Intro_md)
			, ("Manual/6Thanks.md", _Manual_6Thanks_md)
			, ("Manual/TypeTrees2.svg", _Manual_TypeTrees2_svg)
			, ("Manual/2Tutorial.md", _Manual_2Tutorial_md)
			, ("Manual/2.1Tut-Syntax.md", _Manual_2_1Tut_Syntax_md)
			, ("Manual/Focus.generate", _Manual_Focus_generate)
			, ("Manual/TypeTrees0.svg", _Manual_TypeTrees0_svg)
			, ("Manual/TypeTrees1annot.svg", _Manual_TypeTrees1annot_svg)
			, ("Manual/Main.tex", _Manual_Main_tex)
			, ("Manual/TypeTrees2annot1.svg", _Manual_TypeTrees2annot1_svg)
			, ("Manual/3ReferenceManual.md", _Manual_3ReferenceManual_md)
			, ("Manual/4Concepts.md", _Manual_4Concepts_md)
			, ("Manual/TypeTrees2annot.svg", _Manual_TypeTrees2annot_svg)
			, ("Manual/5Gradualization.md", _Manual_5Gradualization_md)
			, ("Manual/Manual.generate", _Manual_Manual_generate)
			, ("Manual/Options.language", _Manual_Options_language)
			, ("Manual/build.sh", _Manual_build_sh)
			, ("Manual/1Overview.md", _Manual_1Overview_md)
			, ("Manual/TypeTrees0annot.svg", _Manual_TypeTrees0annot_svg)
			, ("Manual/2.2Tut-Functions.md", _Manual_2_2Tut_Functions_md)
			, ("Manual/0Introduction.md", _Manual_0Introduction_md)
			, ("Manual/Files/examples.stfl", _Manual_Files_examples_stfl)
			, ("Manual/Files/typeExamples.stfl", _Manual_Files_typeExamples_stfl)
			, ("Manual/Files/STFLForSlides.language", _Manual_Files_STFLForSlides_language)
			, ("Manual/Files/STFLBool.language", _Manual_Files_STFLBool_language)
			, ("Manual/Files/STFLBoolSimpleExpr.language", _Manual_Files_STFLBoolSimpleExpr_language)
			, ("Manual/Files/STFLrec.language", _Manual_Files_STFLrec_language)
			, ("Manual/Files/STFLInt.language", _Manual_Files_STFLInt_language)
			, ("Manual/Files/STFLWrongOrder.language", _Manual_Files_STFLWrongOrder_language)
			, ("Manual/Files/STFL.language", _Manual_Files_STFL_language)
			, ("Manual/Output/ALGT_Manual.html", _Manual_Output_ALGT_Manual_html)
			, ("Manual/Output/ALGT_Focus.html", _Manual_Output_ALGT_Focus_html)
			, ("Manual/Output/ALGT_FocusRefMan.html", _Manual_Output_ALGT_FocusRefMan_html)
			, ("GTKSourceViewOptions/AppearanceElems", _GTKSourceViewOptions_AppearanceElems)
			, ("GTKSourceViewOptions/ColorOptions", _GTKSourceViewOptions_ColorOptions)
			, ("GTKSourceViewOptions/DefaultStyleElems", _GTKSourceViewOptions_DefaultStyleElems)
			, ("GTKSourceViewOptions/FloatOptions", _GTKSourceViewOptions_FloatOptions)
			, ("GTKSourceViewOptions/Readme.md", _GTKSourceViewOptions_Readme_md)
			, ("GTKSourceViewOptions/BoolOptions.txt", _GTKSourceViewOptions_BoolOptions_txt)
			, ("Test/CommonSubset.language", _Test_CommonSubset_language)
			, ("Test/examples.stfl", _Test_examples_stfl)
			, ("Test/Recursive.language", _Test_Recursive_language)
			, ("Test/LiveCheck.language", _Test_LiveCheck_language)
			, ("Test/DynamizeSTFL.language-changes", _Test_DynamizeSTFL_language_changes)
			, ("Test/GradualizeSTFL.language-changes", _Test_GradualizeSTFL_language_changes)
			, ("Test/STFL.language", _Test_STFL_language)
			, ("IntegrationTests/Parsetrees_13.svg", _IntegrationTests_Parsetrees_13_svg)
			, ("IntegrationTests/_Test_STFL_languageTest_examples_stfle_l", _IntegrationTests__Test_STFL_languageTest_examples_stfle_l)
			, ("IntegrationTests/Parsetrees_12.svg", _IntegrationTests_Parsetrees_12_svg)
			, ("IntegrationTests/_Test_STFL_languageTest_examples_stfle_l__tpa", _IntegrationTests__Test_STFL_languageTest_examples_stfle_l__tpa)
			, ("IntegrationTests/_log___Test_STFL_languageTest_examples_stfle_l_r__", _IntegrationTests__log___Test_STFL_languageTest_examples_stfle_l_r__)
			, ("IntegrationTests/_Test_Recursive_language__dlf", _IntegrationTests__Test_Recursive_language__dlf)
			, ("IntegrationTests/_Test_STFL_language__lsvgSyntax_svg", _IntegrationTests__Test_STFL_language__lsvgSyntax_svg)
			, ("IntegrationTests/_log___Test_STFL_language__irEvalCtx", _IntegrationTests__log___Test_STFL_language__irEvalCtx)
			, ("IntegrationTests/Parsetrees_6.svg", _IntegrationTests_Parsetrees_6_svg)
			, ("IntegrationTests/Parsetrees_1.svg", _IntegrationTests_Parsetrees_1_svg)
			, ("IntegrationTests/Parsetrees_0.svg", _IntegrationTests_Parsetrees_0_svg)
			, ("IntegrationTests/Parsetrees_9.svg", _IntegrationTests_Parsetrees_9_svg)
			, ("IntegrationTests/_log___Test_STFL_languageTest_examples_stfle_l", _IntegrationTests__log___Test_STFL_languageTest_examples_stfle_l)
			, ("IntegrationTests/Parsetrees_2.svg", _IntegrationTests_Parsetrees_2_svg)
			, ("IntegrationTests/_log___Test_STFL_language__lsvgSyntax_svg", _IntegrationTests__log___Test_STFL_language__lsvgSyntax_svg)
			, ("IntegrationTests/_log___Test_STFL_languageTest_examples_stfle_l__tpProgress", _IntegrationTests__log___Test_STFL_languageTest_examples_stfle_l__tpProgress)
			, ("IntegrationTests/_Test_STFL_languageTest_examples_stfle_l__tpa__ppp", _IntegrationTests__Test_STFL_languageTest_examples_stfle_l__tpa__ppp)
			, ("IntegrationTests/_log___Test_STFL_language_cTest_DynamizeSTFL_language_changes_cTest_GradualizeSTFL_language_changes__dlf", _IntegrationTests__log___Test_STFL_language_cTest_DynamizeSTFL_language_changes_cTest_GradualizeSTFL_language_changes__dlf)
			, ("IntegrationTests/_log___Test_STFL_language__dlf", _IntegrationTests__log___Test_STFL_language__dlf)
			, ("IntegrationTests/Parsetrees_17.svg", _IntegrationTests_Parsetrees_17_svg)
			, ("IntegrationTests/Parsetrees_20.svg", _IntegrationTests_Parsetrees_20_svg)
			, ("IntegrationTests/_Test_STFL_languageTest_examples_stfle_l__ptsvgParsetrees", _IntegrationTests__Test_STFL_languageTest_examples_stfle_l__ptsvgParsetrees)
			, ("IntegrationTests/_Test_STFL_language", _IntegrationTests__Test_STFL_language)
			, ("IntegrationTests/Parsetrees_23.svg", _IntegrationTests_Parsetrees_23_svg)
			, ("IntegrationTests/_Test_STFL_language__irEvalCtx", _IntegrationTests__Test_STFL_language__irEvalCtx)
			, ("IntegrationTests/_log___Test_STFL_language_cTest_DynamizeSTFL_language_changes__dlf", _IntegrationTests__log___Test_STFL_language_cTest_DynamizeSTFL_language_changes__dlf)
			, ("IntegrationTests/Parsetrees_4.svg", _IntegrationTests_Parsetrees_4_svg)
			, ("IntegrationTests/Parsetrees_14.svg", _IntegrationTests_Parsetrees_14_svg)
			, ("IntegrationTests/_log___Test_STFL_languageTest_examples_stfle_l__ptsvgParsetrees", _IntegrationTests__log___Test_STFL_languageTest_examples_stfle_l__ptsvgParsetrees)
			, ("IntegrationTests/_Test_STFL_language_cTest_DynamizeSTFL_language_changes__dlf", _IntegrationTests__Test_STFL_language_cTest_DynamizeSTFL_language_changes__dlf)
			, ("IntegrationTests/Parsetrees_16.svg", _IntegrationTests_Parsetrees_16_svg)
			, ("IntegrationTests/_Test_STFL_language__irasvgSyntaxIRA_svg", _IntegrationTests__Test_STFL_language__irasvgSyntaxIRA_svg)
			, ("IntegrationTests/Parsetrees_22.svg", _IntegrationTests_Parsetrees_22_svg)
			, ("IntegrationTests/_log___Test_CommonSubset_language__dlf", _IntegrationTests__log___Test_CommonSubset_language__dlf)
			, ("IntegrationTests/Parsetrees_5.svg", _IntegrationTests_Parsetrees_5_svg)
			, ("IntegrationTests/_log___Test_STFL_language", _IntegrationTests__log___Test_STFL_language)
			, ("IntegrationTests/_Test_STFL_language__ira", _IntegrationTests__Test_STFL_language__ira)
			, ("IntegrationTests/_Test_STFL_languageTest_examples_stfle_l__tpProgress", _IntegrationTests__Test_STFL_languageTest_examples_stfle_l__tpProgress)
			, ("IntegrationTests/_log___Test_STFL_language__irasvgSyntaxIRA_svg", _IntegrationTests__log___Test_STFL_language__irasvgSyntaxIRA_svg)
			, ("IntegrationTests/_Test_STFL_language__dlf", _IntegrationTests__Test_STFL_language__dlf)
			, ("IntegrationTests/_Test_STFL_languageTest_examples_stfle_l_r__", _IntegrationTests__Test_STFL_languageTest_examples_stfle_l_r__)
			, ("IntegrationTests/Parsetrees_11.svg", _IntegrationTests_Parsetrees_11_svg)
			, ("IntegrationTests/Parsetrees_8.svg", _IntegrationTests_Parsetrees_8_svg)
			, ("IntegrationTests/Syntax.svg", _IntegrationTests_Syntax_svg)
			, ("IntegrationTests/Parsetrees_10.svg", _IntegrationTests_Parsetrees_10_svg)
			, ("IntegrationTests/Parsetrees_18.svg", _IntegrationTests_Parsetrees_18_svg)
			, ("IntegrationTests/SyntaxIRA.svg", _IntegrationTests_SyntaxIRA_svg)
			, ("IntegrationTests/_Test_STFL_language_cTest_DynamizeSTFL_language_changes_cTest_GradualizeSTFL_language_changes__dlf", _IntegrationTests__Test_STFL_language_cTest_DynamizeSTFL_language_changes_cTest_GradualizeSTFL_language_changes__dlf)
			, ("IntegrationTests/Parsetrees_3.svg", _IntegrationTests_Parsetrees_3_svg)
			, ("IntegrationTests/_log___Test_STFL_languageTest_examples_stfle_l__tpProgress__ppp", _IntegrationTests__log___Test_STFL_languageTest_examples_stfle_l__tpProgress__ppp)
			, ("IntegrationTests/_Test_STFL_languageTest_examples_stfle_l__tpProgress__ppp", _IntegrationTests__Test_STFL_languageTest_examples_stfle_l__tpProgress__ppp)
			, ("IntegrationTests/Parsetrees_15.svg", _IntegrationTests_Parsetrees_15_svg)
			, ("IntegrationTests/_Test_CommonSubset_language__dlf", _IntegrationTests__Test_CommonSubset_language__dlf)
			, ("IntegrationTests/_log___Test_STFL_languageTest_examples_stfle_l__tpa", _IntegrationTests__log___Test_STFL_languageTest_examples_stfle_l__tpa)
			, ("IntegrationTests/_log___Test_STFL_languageTest_examples_stfle_l__tpa__ppp", _IntegrationTests__log___Test_STFL_languageTest_examples_stfle_l__tpa__ppp)
			, ("IntegrationTests/_log___Test_STFL_languageTest_examples_stfle_l_r_", _IntegrationTests__log___Test_STFL_languageTest_examples_stfle_l_r_)
			, ("IntegrationTests/Parsetrees_7.svg", _IntegrationTests_Parsetrees_7_svg)
			, ("IntegrationTests/_log___Test_STFL_language__ira", _IntegrationTests__log___Test_STFL_language__ira)
			, ("IntegrationTests/_Test_STFL_languageTest_examples_stfle_l_r_", _IntegrationTests__Test_STFL_languageTest_examples_stfle_l_r_)
			, ("IntegrationTests/Parsetrees_21.svg", _IntegrationTests_Parsetrees_21_svg)
			, ("IntegrationTests/_log___Test_Recursive_language__dlf", _IntegrationTests__log___Test_Recursive_language__dlf)
			, ("IntegrationTests/Parsetrees_19.svg", _IntegrationTests_Parsetrees_19_svg)
			]

{-# NOINLINE _White_style #-}
_White_style
	 = unsafePerformIO $ readFile "Assets/White.style"

{-# NOINLINE _WhiteFlat_style #-}
_WhiteFlat_style
	 = unsafePerformIO $ readFile "Assets/WhiteFlat.style"

{-# NOINLINE _language_changes_lang #-}
_language_changes_lang
	 = unsafePerformIO $ readFile "Assets/language-changes.lang"

{-# NOINLINE _Style_language #-}
_Style_language
	 = unsafePerformIO $ readFile "Assets/Style.language"

{-# NOINLINE _Terminal_style #-}
_Terminal_style
	 = unsafePerformIO $ readFile "Assets/Terminal.style"

{-# NOINLINE _language_lang #-}
_language_lang
	 = unsafePerformIO $ readFile "Assets/language.lang"

{-# NOINLINE _Manual_TypeTrees1_svg #-}
_Manual_TypeTrees1_svg
	 = unsafePerformIO $ readFile "Assets/Manual/TypeTrees1.svg"

{-# NOINLINE _Manual_2_0Tut_Intro_md #-}
_Manual_2_0Tut_Intro_md
	 = unsafePerformIO $ readFile "Assets/Manual/2.0Tut-Intro.md"

{-# NOINLINE _Manual_6Thanks_md #-}
_Manual_6Thanks_md
	 = unsafePerformIO $ readFile "Assets/Manual/6Thanks.md"

{-# NOINLINE _Manual_TypeTrees2_svg #-}
_Manual_TypeTrees2_svg
	 = unsafePerformIO $ readFile "Assets/Manual/TypeTrees2.svg"

{-# NOINLINE _Manual_2Tutorial_md #-}
_Manual_2Tutorial_md
	 = unsafePerformIO $ readFile "Assets/Manual/2Tutorial.md"

{-# NOINLINE _Manual_hofstadter_png #-}
_Manual_hofstadter_png
	 = unsafePerformIO $ B.readFile "Assets/Manual/hofstadter.png"

{-# NOINLINE _Manual_2_1Tut_Syntax_md #-}
_Manual_2_1Tut_Syntax_md
	 = unsafePerformIO $ readFile "Assets/Manual/2.1Tut-Syntax.md"

{-# NOINLINE _Manual_Rules_png #-}
_Manual_Rules_png
	 = unsafePerformIO $ B.readFile "Assets/Manual/Rules.png"

{-# NOINLINE _Manual_Focus_generate #-}
_Manual_Focus_generate
	 = unsafePerformIO $ readFile "Assets/Manual/Focus.generate"

{-# NOINLINE _Manual_TypeTrees0_svg #-}
_Manual_TypeTrees0_svg
	 = unsafePerformIO $ readFile "Assets/Manual/TypeTrees0.svg"

{-# NOINLINE _Manual_TypeTrees1annot_svg #-}
_Manual_TypeTrees1annot_svg
	 = unsafePerformIO $ readFile "Assets/Manual/TypeTrees1annot.svg"

{-# NOINLINE _Manual_Main_tex #-}
_Manual_Main_tex
	 = unsafePerformIO $ readFile "Assets/Manual/Main.tex"

{-# NOINLINE _Manual_TypeTrees2annot1_svg #-}
_Manual_TypeTrees2annot1_svg
	 = unsafePerformIO $ readFile "Assets/Manual/TypeTrees2annot1.svg"

{-# NOINLINE _Manual_3ReferenceManual_md #-}
_Manual_3ReferenceManual_md
	 = unsafePerformIO $ readFile "Assets/Manual/3ReferenceManual.md"

{-# NOINLINE _Manual_4Concepts_md #-}
_Manual_4Concepts_md
	 = unsafePerformIO $ readFile "Assets/Manual/4Concepts.md"

{-# NOINLINE _Manual_TypeTrees2annot_svg #-}
_Manual_TypeTrees2annot_svg
	 = unsafePerformIO $ readFile "Assets/Manual/TypeTrees2annot.svg"

{-# NOINLINE _Manual_ConsTrans_png #-}
_Manual_ConsTrans_png
	 = unsafePerformIO $ B.readFile "Assets/Manual/ConsTrans.png"

{-# NOINLINE _Manual_5Gradualization_md #-}
_Manual_5Gradualization_md
	 = unsafePerformIO $ readFile "Assets/Manual/5Gradualization.md"

{-# NOINLINE _Manual_Manual_generate #-}
_Manual_Manual_generate
	 = unsafePerformIO $ readFile "Assets/Manual/Manual.generate"

{-# NOINLINE _Manual_Options_language #-}
_Manual_Options_language
	 = unsafePerformIO $ readFile "Assets/Manual/Options.language"

{-# NOINLINE _Manual_build_sh #-}
_Manual_build_sh
	 = unsafePerformIO $ readFile "Assets/Manual/build.sh"

{-# NOINLINE _Manual_1Overview_md #-}
_Manual_1Overview_md
	 = unsafePerformIO $ readFile "Assets/Manual/1Overview.md"

{-# NOINLINE _Manual_TypeTrees0annot_svg #-}
_Manual_TypeTrees0annot_svg
	 = unsafePerformIO $ readFile "Assets/Manual/TypeTrees0annot.svg"

{-# NOINLINE _Manual_2_2Tut_Functions_md #-}
_Manual_2_2Tut_Functions_md
	 = unsafePerformIO $ readFile "Assets/Manual/2.2Tut-Functions.md"

{-# NOINLINE _Manual_0Introduction_md #-}
_Manual_0Introduction_md
	 = unsafePerformIO $ readFile "Assets/Manual/0Introduction.md"

{-# NOINLINE _Manual_Files_examples_stfl #-}
_Manual_Files_examples_stfl
	 = unsafePerformIO $ readFile "Assets/Manual/Files/examples.stfl"

{-# NOINLINE _Manual_Files_typeExamples_stfl #-}
_Manual_Files_typeExamples_stfl
	 = unsafePerformIO $ readFile "Assets/Manual/Files/typeExamples.stfl"

{-# NOINLINE _Manual_Files_STFLForSlides_language #-}
_Manual_Files_STFLForSlides_language
	 = unsafePerformIO $ readFile "Assets/Manual/Files/STFLForSlides.language"

{-# NOINLINE _Manual_Files_STFLBool_language #-}
_Manual_Files_STFLBool_language
	 = unsafePerformIO $ readFile "Assets/Manual/Files/STFLBool.language"

{-# NOINLINE _Manual_Files_STFLBoolSimpleExpr_language #-}
_Manual_Files_STFLBoolSimpleExpr_language
	 = unsafePerformIO $ readFile "Assets/Manual/Files/STFLBoolSimpleExpr.language"

{-# NOINLINE _Manual_Files_STFLrec_language #-}
_Manual_Files_STFLrec_language
	 = unsafePerformIO $ readFile "Assets/Manual/Files/STFLrec.language"

{-# NOINLINE _Manual_Files_STFLInt_language #-}
_Manual_Files_STFLInt_language
	 = unsafePerformIO $ readFile "Assets/Manual/Files/STFLInt.language"

{-# NOINLINE _Manual_Files_STFLWrongOrder_language #-}
_Manual_Files_STFLWrongOrder_language
	 = unsafePerformIO $ readFile "Assets/Manual/Files/STFLWrongOrder.language"

{-# NOINLINE _Manual_Files_STFL_language #-}
_Manual_Files_STFL_language
	 = unsafePerformIO $ readFile "Assets/Manual/Files/STFL.language"

{-# NOINLINE _Manual_Output_ALGT_Focus_pdf #-}
_Manual_Output_ALGT_Focus_pdf
	 = unsafePerformIO $ B.readFile "Assets/Manual/Output/ALGT_Focus.pdf"

{-# NOINLINE _Manual_Output_ALGT_Manual_html #-}
_Manual_Output_ALGT_Manual_html
	 = unsafePerformIO $ readFile "Assets/Manual/Output/ALGT_Manual.html"

{-# NOINLINE _Manual_Output_ALGT_FocusRefMan_pdf #-}
_Manual_Output_ALGT_FocusRefMan_pdf
	 = unsafePerformIO $ B.readFile "Assets/Manual/Output/ALGT_FocusRefMan.pdf"

{-# NOINLINE _Manual_Output_ALGT_Focus_html #-}
_Manual_Output_ALGT_Focus_html
	 = unsafePerformIO $ readFile "Assets/Manual/Output/ALGT_Focus.html"

{-# NOINLINE _Manual_Output_ALGT_Manual_pdf #-}
_Manual_Output_ALGT_Manual_pdf
	 = unsafePerformIO $ B.readFile "Assets/Manual/Output/ALGT_Manual.pdf"

{-# NOINLINE _Manual_Output_ALGT_FocusRefMan_html #-}
_Manual_Output_ALGT_FocusRefMan_html
	 = unsafePerformIO $ readFile "Assets/Manual/Output/ALGT_FocusRefMan.html"

{-# NOINLINE _GTKSourceViewOptions_AppearanceElems #-}
_GTKSourceViewOptions_AppearanceElems
	 = unsafePerformIO $ readFile "Assets/GTKSourceViewOptions/AppearanceElems"

{-# NOINLINE _GTKSourceViewOptions_ColorOptions #-}
_GTKSourceViewOptions_ColorOptions
	 = unsafePerformIO $ readFile "Assets/GTKSourceViewOptions/ColorOptions"

{-# NOINLINE _GTKSourceViewOptions_DefaultStyleElems #-}
_GTKSourceViewOptions_DefaultStyleElems
	 = unsafePerformIO $ readFile "Assets/GTKSourceViewOptions/DefaultStyleElems"

{-# NOINLINE _GTKSourceViewOptions_FloatOptions #-}
_GTKSourceViewOptions_FloatOptions
	 = unsafePerformIO $ readFile "Assets/GTKSourceViewOptions/FloatOptions"

{-# NOINLINE _GTKSourceViewOptions_Readme_md #-}
_GTKSourceViewOptions_Readme_md
	 = unsafePerformIO $ readFile "Assets/GTKSourceViewOptions/Readme.md"

{-# NOINLINE _GTKSourceViewOptions_BoolOptions_txt #-}
_GTKSourceViewOptions_BoolOptions_txt
	 = unsafePerformIO $ readFile "Assets/GTKSourceViewOptions/BoolOptions.txt"

{-# NOINLINE _Test_CommonSubset_language #-}
_Test_CommonSubset_language
	 = unsafePerformIO $ readFile "Assets/Test/CommonSubset.language"

{-# NOINLINE _Test_examples_stfl #-}
_Test_examples_stfl
	 = unsafePerformIO $ readFile "Assets/Test/examples.stfl"

{-# NOINLINE _Test_Recursive_language #-}
_Test_Recursive_language
	 = unsafePerformIO $ readFile "Assets/Test/Recursive.language"

{-# NOINLINE _Test_LiveCheck_language #-}
_Test_LiveCheck_language
	 = unsafePerformIO $ readFile "Assets/Test/LiveCheck.language"

{-# NOINLINE _Test_DynamizeSTFL_language_changes #-}
_Test_DynamizeSTFL_language_changes
	 = unsafePerformIO $ readFile "Assets/Test/DynamizeSTFL.language-changes"

{-# NOINLINE _Test_GradualizeSTFL_language_changes #-}
_Test_GradualizeSTFL_language_changes
	 = unsafePerformIO $ readFile "Assets/Test/GradualizeSTFL.language-changes"

{-# NOINLINE _Test_STFL_language #-}
_Test_STFL_language
	 = unsafePerformIO $ readFile "Assets/Test/STFL.language"

{-# NOINLINE _IntegrationTests_Parsetrees_13_svg #-}
_IntegrationTests_Parsetrees_13_svg
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/Parsetrees_13.svg"

{-# NOINLINE _IntegrationTests__Test_STFL_languageTest_examples_stfle_l #-}
_IntegrationTests__Test_STFL_languageTest_examples_stfle_l
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_Test_STFL_languageTest_examples_stfle_l"

{-# NOINLINE _IntegrationTests_Parsetrees_12_svg #-}
_IntegrationTests_Parsetrees_12_svg
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/Parsetrees_12.svg"

{-# NOINLINE _IntegrationTests__Test_STFL_languageTest_examples_stfle_l__tpa #-}
_IntegrationTests__Test_STFL_languageTest_examples_stfle_l__tpa
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_Test_STFL_languageTest_examples_stfle_l__tpa"

{-# NOINLINE _IntegrationTests__log___Test_STFL_languageTest_examples_stfle_l_r__ #-}
_IntegrationTests__log___Test_STFL_languageTest_examples_stfle_l_r__
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_log___Test_STFL_languageTest_examples_stfle_l_r__"

{-# NOINLINE _IntegrationTests__Test_Recursive_language__dlf #-}
_IntegrationTests__Test_Recursive_language__dlf
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_Test_Recursive_language__dlf"

{-# NOINLINE _IntegrationTests__Test_STFL_language__lsvgSyntax_svg #-}
_IntegrationTests__Test_STFL_language__lsvgSyntax_svg
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_Test_STFL_language__lsvgSyntax_svg"

{-# NOINLINE _IntegrationTests__log___Test_STFL_language__irEvalCtx #-}
_IntegrationTests__log___Test_STFL_language__irEvalCtx
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_log___Test_STFL_language__irEvalCtx"

{-# NOINLINE _IntegrationTests_Parsetrees_6_svg #-}
_IntegrationTests_Parsetrees_6_svg
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/Parsetrees_6.svg"

{-# NOINLINE _IntegrationTests_Parsetrees_1_svg #-}
_IntegrationTests_Parsetrees_1_svg
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/Parsetrees_1.svg"

{-# NOINLINE _IntegrationTests_Parsetrees_0_svg #-}
_IntegrationTests_Parsetrees_0_svg
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/Parsetrees_0.svg"

{-# NOINLINE _IntegrationTests_Parsetrees_9_svg #-}
_IntegrationTests_Parsetrees_9_svg
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/Parsetrees_9.svg"

{-# NOINLINE _IntegrationTests__log___Test_STFL_languageTest_examples_stfle_l #-}
_IntegrationTests__log___Test_STFL_languageTest_examples_stfle_l
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_log___Test_STFL_languageTest_examples_stfle_l"

{-# NOINLINE _IntegrationTests_Parsetrees_2_svg #-}
_IntegrationTests_Parsetrees_2_svg
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/Parsetrees_2.svg"

{-# NOINLINE _IntegrationTests__log___Test_STFL_language__lsvgSyntax_svg #-}
_IntegrationTests__log___Test_STFL_language__lsvgSyntax_svg
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_log___Test_STFL_language__lsvgSyntax_svg"

{-# NOINLINE _IntegrationTests__log___Test_STFL_languageTest_examples_stfle_l__tpProgress #-}
_IntegrationTests__log___Test_STFL_languageTest_examples_stfle_l__tpProgress
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_log___Test_STFL_languageTest_examples_stfle_l__tpProgress"

{-# NOINLINE _IntegrationTests__Test_STFL_languageTest_examples_stfle_l__tpa__ppp #-}
_IntegrationTests__Test_STFL_languageTest_examples_stfle_l__tpa__ppp
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_Test_STFL_languageTest_examples_stfle_l__tpa__ppp"

{-# NOINLINE _IntegrationTests__log___Test_STFL_language_cTest_DynamizeSTFL_language_changes_cTest_GradualizeSTFL_language_changes__dlf #-}
_IntegrationTests__log___Test_STFL_language_cTest_DynamizeSTFL_language_changes_cTest_GradualizeSTFL_language_changes__dlf
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_log___Test_STFL_language_cTest_DynamizeSTFL_language_changes_cTest_GradualizeSTFL_language_changes__dlf"

{-# NOINLINE _IntegrationTests__log___Test_STFL_language__dlf #-}
_IntegrationTests__log___Test_STFL_language__dlf
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_log___Test_STFL_language__dlf"

{-# NOINLINE _IntegrationTests_Parsetrees_17_svg #-}
_IntegrationTests_Parsetrees_17_svg
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/Parsetrees_17.svg"

{-# NOINLINE _IntegrationTests_Parsetrees_20_svg #-}
_IntegrationTests_Parsetrees_20_svg
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/Parsetrees_20.svg"

{-# NOINLINE _IntegrationTests__Test_STFL_languageTest_examples_stfle_l__ptsvgParsetrees #-}
_IntegrationTests__Test_STFL_languageTest_examples_stfle_l__ptsvgParsetrees
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_Test_STFL_languageTest_examples_stfle_l__ptsvgParsetrees"

{-# NOINLINE _IntegrationTests__Test_STFL_language #-}
_IntegrationTests__Test_STFL_language
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_Test_STFL_language"

{-# NOINLINE _IntegrationTests_Parsetrees_23_svg #-}
_IntegrationTests_Parsetrees_23_svg
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/Parsetrees_23.svg"

{-# NOINLINE _IntegrationTests__Test_STFL_language__irEvalCtx #-}
_IntegrationTests__Test_STFL_language__irEvalCtx
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_Test_STFL_language__irEvalCtx"

{-# NOINLINE _IntegrationTests__log___Test_STFL_language_cTest_DynamizeSTFL_language_changes__dlf #-}
_IntegrationTests__log___Test_STFL_language_cTest_DynamizeSTFL_language_changes__dlf
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_log___Test_STFL_language_cTest_DynamizeSTFL_language_changes__dlf"

{-# NOINLINE _IntegrationTests_Parsetrees_4_svg #-}
_IntegrationTests_Parsetrees_4_svg
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/Parsetrees_4.svg"

{-# NOINLINE _IntegrationTests_Parsetrees_14_svg #-}
_IntegrationTests_Parsetrees_14_svg
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/Parsetrees_14.svg"

{-# NOINLINE _IntegrationTests__log___Test_STFL_languageTest_examples_stfle_l__ptsvgParsetrees #-}
_IntegrationTests__log___Test_STFL_languageTest_examples_stfle_l__ptsvgParsetrees
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_log___Test_STFL_languageTest_examples_stfle_l__ptsvgParsetrees"

{-# NOINLINE _IntegrationTests__Test_STFL_language_cTest_DynamizeSTFL_language_changes__dlf #-}
_IntegrationTests__Test_STFL_language_cTest_DynamizeSTFL_language_changes__dlf
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_Test_STFL_language_cTest_DynamizeSTFL_language_changes__dlf"

{-# NOINLINE _IntegrationTests_Parsetrees_16_svg #-}
_IntegrationTests_Parsetrees_16_svg
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/Parsetrees_16.svg"

{-# NOINLINE _IntegrationTests__Test_STFL_language__irasvgSyntaxIRA_svg #-}
_IntegrationTests__Test_STFL_language__irasvgSyntaxIRA_svg
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_Test_STFL_language__irasvgSyntaxIRA_svg"

{-# NOINLINE _IntegrationTests_Parsetrees_22_svg #-}
_IntegrationTests_Parsetrees_22_svg
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/Parsetrees_22.svg"

{-# NOINLINE _IntegrationTests__log___Test_CommonSubset_language__dlf #-}
_IntegrationTests__log___Test_CommonSubset_language__dlf
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_log___Test_CommonSubset_language__dlf"

{-# NOINLINE _IntegrationTests_Parsetrees_5_svg #-}
_IntegrationTests_Parsetrees_5_svg
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/Parsetrees_5.svg"

{-# NOINLINE _IntegrationTests__log___Test_STFL_language #-}
_IntegrationTests__log___Test_STFL_language
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_log___Test_STFL_language"

{-# NOINLINE _IntegrationTests__Test_STFL_language__ira #-}
_IntegrationTests__Test_STFL_language__ira
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_Test_STFL_language__ira"

{-# NOINLINE _IntegrationTests__Test_STFL_languageTest_examples_stfle_l__tpProgress #-}
_IntegrationTests__Test_STFL_languageTest_examples_stfle_l__tpProgress
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_Test_STFL_languageTest_examples_stfle_l__tpProgress"

{-# NOINLINE _IntegrationTests__log___Test_STFL_language__irasvgSyntaxIRA_svg #-}
_IntegrationTests__log___Test_STFL_language__irasvgSyntaxIRA_svg
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_log___Test_STFL_language__irasvgSyntaxIRA_svg"

{-# NOINLINE _IntegrationTests__Test_STFL_language__dlf #-}
_IntegrationTests__Test_STFL_language__dlf
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_Test_STFL_language__dlf"

{-# NOINLINE _IntegrationTests__Test_STFL_languageTest_examples_stfle_l_r__ #-}
_IntegrationTests__Test_STFL_languageTest_examples_stfle_l_r__
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_Test_STFL_languageTest_examples_stfle_l_r__"

{-# NOINLINE _IntegrationTests_Parsetrees_11_svg #-}
_IntegrationTests_Parsetrees_11_svg
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/Parsetrees_11.svg"

{-# NOINLINE _IntegrationTests_Parsetrees_8_svg #-}
_IntegrationTests_Parsetrees_8_svg
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/Parsetrees_8.svg"

{-# NOINLINE _IntegrationTests_Syntax_svg #-}
_IntegrationTests_Syntax_svg
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/Syntax.svg"

{-# NOINLINE _IntegrationTests_Parsetrees_10_svg #-}
_IntegrationTests_Parsetrees_10_svg
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/Parsetrees_10.svg"

{-# NOINLINE _IntegrationTests_Parsetrees_18_svg #-}
_IntegrationTests_Parsetrees_18_svg
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/Parsetrees_18.svg"

{-# NOINLINE _IntegrationTests_SyntaxIRA_svg #-}
_IntegrationTests_SyntaxIRA_svg
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/SyntaxIRA.svg"

{-# NOINLINE _IntegrationTests__Test_STFL_language_cTest_DynamizeSTFL_language_changes_cTest_GradualizeSTFL_language_changes__dlf #-}
_IntegrationTests__Test_STFL_language_cTest_DynamizeSTFL_language_changes_cTest_GradualizeSTFL_language_changes__dlf
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_Test_STFL_language_cTest_DynamizeSTFL_language_changes_cTest_GradualizeSTFL_language_changes__dlf"

{-# NOINLINE _IntegrationTests_Parsetrees_3_svg #-}
_IntegrationTests_Parsetrees_3_svg
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/Parsetrees_3.svg"

{-# NOINLINE _IntegrationTests__log___Test_STFL_languageTest_examples_stfle_l__tpProgress__ppp #-}
_IntegrationTests__log___Test_STFL_languageTest_examples_stfle_l__tpProgress__ppp
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_log___Test_STFL_languageTest_examples_stfle_l__tpProgress__ppp"

{-# NOINLINE _IntegrationTests__Test_STFL_languageTest_examples_stfle_l__tpProgress__ppp #-}
_IntegrationTests__Test_STFL_languageTest_examples_stfle_l__tpProgress__ppp
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_Test_STFL_languageTest_examples_stfle_l__tpProgress__ppp"

{-# NOINLINE _IntegrationTests_Parsetrees_15_svg #-}
_IntegrationTests_Parsetrees_15_svg
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/Parsetrees_15.svg"

{-# NOINLINE _IntegrationTests__Test_CommonSubset_language__dlf #-}
_IntegrationTests__Test_CommonSubset_language__dlf
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_Test_CommonSubset_language__dlf"

{-# NOINLINE _IntegrationTests__log___Test_STFL_languageTest_examples_stfle_l__tpa #-}
_IntegrationTests__log___Test_STFL_languageTest_examples_stfle_l__tpa
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_log___Test_STFL_languageTest_examples_stfle_l__tpa"

{-# NOINLINE _IntegrationTests__log___Test_STFL_languageTest_examples_stfle_l__tpa__ppp #-}
_IntegrationTests__log___Test_STFL_languageTest_examples_stfle_l__tpa__ppp
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_log___Test_STFL_languageTest_examples_stfle_l__tpa__ppp"

{-# NOINLINE _IntegrationTests__log___Test_STFL_languageTest_examples_stfle_l_r_ #-}
_IntegrationTests__log___Test_STFL_languageTest_examples_stfle_l_r_
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_log___Test_STFL_languageTest_examples_stfle_l_r_"

{-# NOINLINE _IntegrationTests_Parsetrees_7_svg #-}
_IntegrationTests_Parsetrees_7_svg
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/Parsetrees_7.svg"

{-# NOINLINE _IntegrationTests__log___Test_STFL_language__ira #-}
_IntegrationTests__log___Test_STFL_language__ira
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_log___Test_STFL_language__ira"

{-# NOINLINE _IntegrationTests__Test_STFL_languageTest_examples_stfle_l_r_ #-}
_IntegrationTests__Test_STFL_languageTest_examples_stfle_l_r_
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_Test_STFL_languageTest_examples_stfle_l_r_"

{-# NOINLINE _IntegrationTests_Parsetrees_21_svg #-}
_IntegrationTests_Parsetrees_21_svg
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/Parsetrees_21.svg"

{-# NOINLINE _IntegrationTests__log___Test_Recursive_language__dlf #-}
_IntegrationTests__log___Test_Recursive_language__dlf
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/_log___Test_Recursive_language__dlf"

{-# NOINLINE _IntegrationTests_Parsetrees_19_svg #-}
_IntegrationTests_Parsetrees_19_svg
	 = unsafePerformIO $ readFile "Assets/IntegrationTests/Parsetrees_19.svg"
