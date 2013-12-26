//
//  AlertConstants.h
//  iCityPediaUniversal
//
//  Created by Gopesh Kumar Gupta on 21/01/13.
//
//

#ifndef iCityPediaUniversal_AlertConstants_h
#define iCityPediaUniversal_AlertConstants_h

//ALERTVIEW TITLE
#define kAlertViewTitleAlert @"Alert"
#define kAlertViewTitleChangeCategory @"Change category name"
#define kAlertViewTitleAudioDownload @"Audio Download"
#define kAlertViewTitlePleaseWait @"Please Wait"
#define kAlertViewTitleCongratulations @"Congratulations!!!"
#define kAlertViewTitleCategoryNameRequired @"Category name required"
#define kAlertViewTitleNoCategorySelected @"No Category Selected"
#define kAlertViewTitleAudioInstall @"Audio Install"
#define kAlertViewTitleSuccess @"Success"
#define kAlertViewTitleEntriesRequired @"Entries Required"
#define kAlertViewTitleNotFound @"Not Found"
#define kAlertViewTitleInternetConnectionFailed @"Internet Connection Failed"
#define kAlertViewTitleThankYou @"Thank You"
#define kAlertViewTitleError @"Error"
#define kAlertViewTitleNoNetworkAvailable @"No Network Available"
#define kAlertViewTitleCategorySuccessfullyAdded @"Category successfully added"
#define kAlertViewTitleContributionAppreciated @"Contribution appreciated"
#define kAlertViewTitleCategoryNameUpdated @"Category name saved"
#define kAlertViewTitleAudioInstallationInProgress @"Audio installation is in progress"
#define kAlertViewTitleDownloading @"Downloading"
#define kAlertViewTitleSorry @"Sorry !!"
#define kAlertViewTitleOops @"Oops.."
#define kAlertViewTitlePackageDownloadInProgress @"Package download is in progress"
#define kAlertViewTitleSaved @"Saved"
#define kAlertViewTitleCannotRestorePurchase @"Cannot Restore Purchase"
#define kAlertViewTitleCannotCompletePurchase @"Cannot Complete Purchase"
#define kAlertViewTitleForPackageNotDownloaded @"Package Not Downloaded"

//ALERTVIEW BUTTON
#define kAlertViewButtonYes @"Yes"
#define kAlertViewButtonNo  @"No"
#define kAlertViewButtonOk  @"Ok"
#define kAlertViewButtonInstall @"Install"
#define kAlertViewButtonNotNow @"Not Now"
#define kAlertViewButtonCancel @"Cancel"
#define kAlertViewButtonClear @"Clear"


//ALERTVIEW MESSAGE
#define kAlertViewMessageForCancelActiveDownload @"Do you want to cancel your active download?"
#define kAlertViewMessageForNoActiveDownload @"You have no Active Download"
#define kAlertViewMessageForAlreadyExistingCategory @"This category name already exists. Rename the category, and then add words in it."
#define kAlertViewMessageForCategoryDescriptionLimit @"Category Description can't be more than 100 characters."
#define kAlertViewMessageForCategoryNameLimit @"Category Name can't be more than 25 characters."
#define kAlertViewMessageForAudioDownload @"Your package has been downloaded successfully. In order to make full use of the package, we recommend you to download audio files of words. This won't take more than a few minutes."
#define kAlertViewMessageForNotHavingEnglishAudio @"You don't have audios of English. Please download English Audios by clicking on package."

#define kAlertViewMessageForAudioDownloadingInProgress @"Downloading audio files for the %@ Package. Please wait for some time. You can clear your 'Active Downloads' if you're facing issues with downloading."

#define kAlertViewMessageAfterDownloadingAllAudioPacks @"your audio files have been downloaded successfully. Now enjoy Autoplay and other features to reap the best out of it."

#define kAlertViewMessageAfterDownloadingOneAudioPack @"Audios for the %@ language have successfully been installed. We recommend you to install audio files for other languages too for a better and effective learning. "

#define kAlertViewMessageForBlankCategoryName @"Category Name can't be left blank."

#define kAlertViewMessageForAudioDownloadAfterDownloadingSomeFiles @"Audio files for some languages in this list are not installed yet. Words from those languages will be skipped during the Autoplay. If you wish to listen to the complete list, you can install the rest of the audios now."

#define kAlertViewMessageAfterSubmittingAddedWordsContribute @"Thanks for submitting your words"

#define kAlertViewMessageAfterSubmittingEditedWordsContribute @"Thanks for submitting your words"

#define kAlertViewMessageForAlreadyInstalledAudioPackage @"Audios already installed for this package"

#define kAlertViewMessageForDeleteOrRenameStaplesDefaultCategory @"You cannot rename or delete default Staples categories. However, you can create new ones, and manage those the way you want."
#define kAlertViewMessageForBlankFieldInFeedback @"Required fields cannot be left blank."

#define kAlertViewMessageAfterSubmittingFeedbackSuccessfully @"Thanks for submitting your feedback with us."

#define kAlertViewMessageForFeedbackNotSubmitted @"Your feedback was not submitted. Please try after sometime."

#define kAlertViewMessageForBuyPackage @"You haven't purchased this package yet! Please purchase this package by clicking Buy button"

#define kAlertViewMessageForNoRecordedAudio @"No recorded audio to play"

#define kAlertViewMessageForEmptyWordOrPhonetic @"Word and Phonetics cannot be empty"
#define kAlertViewMessageAfterAddingWordsToStaplesOrMatchstix @"Selected words have successfully been added to your Staples/Matchstix list(s)."

#define kAlertViewMessageForChooseCategory @"Please choose a category or make a new one to add the selected word(s)."

#define kAlertViewMessageForWordNotFoundInDatabase @"Word Not Found In Database For Other Languages"

#define kAlertViewMessageForInternetConnectionFailedWhileDownloading @"Your current downloads will be removed. Please try after some time."

#define kAlertViewMessageForXMLError @"Error in XML"

#define kAlertViewMessageForSelectWordsToSubmit @"Please select words to submit."
#define kAlertViewMessageForNoNetwork @"We can't perform this function as your data connection seem unavailable now. Please check your network settings."

#define kAlertViewMessageForCategorySuccessfullyAdded @"Category %@ has successfully been added."

#define kAlertViewMessageForContributionAppreciated @"Your word has successfully been saved and moved to Give Back. You can submit it when data connectivity is there."

#define kAlertViewMessageForContributionAppreciatedIpad @"Your word has successfully been saved. You can submit it when data connectivity is there."

#define kAlertViewMessageForCategoryNameUpdated @"Category Name has been saved successfully"

#define kAlertViewMessageForAlreadyPurchasedPackage @"You have already purchased this package"

#define kAlertViewMessageForAudioInstallationInProgress @"You can download only one voice pack at a time.Please wait until your current installation gets completed. You can clear your 'Active Downloads' if you're facing issues with downloading."

#define kAlertViewMessageForDownloadingWhenStarted @"%@ language audios are being downloaded. However, make sure you install audios for other languages for a better and effective learning."

#define kAlertViewMessageForDeletingOrRenamingPredefinedCategory @"You cannot rename or delete default Staples categories. However, you can create new ones, and manage those the way you want."

#define kAlertViewMessageForSuccessfulMessagePostingFacebook @"Message has been successfully posted on your Facebook Wall."

#define kAlertViewMessageForUnSuccessfulMessagePostingFacebook @"Message could not be published"

#define kAlertViewMessageForPackageDownloadInProgress @"You can download only one package at a time. Please wait until your current downloads gets completed."

#define kAlertViewMessageForPackageSuccessfullyInstalled @"Package has been successfully installed."

#define kAlertViewMessageForSettingSaved @"Your Settings have been Saved."

#define kAlertViewMessageForCategorySetting @"Select at least one category to keep exploring LingoDiction's features."

#define kAlertViewMessageForCannotRestorePurchase @"We could not restore your purchase. Try again later."

#define kAlertViewMessageForCannotCompletePurchase @"We could not complete your purchase. Try again later."

#define kAlertViewMessageForPackageNotDownloaded @"Your package is not downloaded completely due to slow Internet Connection or some other reason. Please clear your active downloads using Clear button and try again."

#define kAlertViewMessageForFacebookInvalidAppIdOrToken @"There seems a problem with Facebook authentication. Please try after some time."

#define kAlertViewMessageForRestorePackage @"You have already purchased this package. Please Restore this package by clicking Restore button"

#define kAlertViewMessageForBuyPackage @"You haven't purchased this package yet! Please purchase this package by clicking Buy button"

#endif
