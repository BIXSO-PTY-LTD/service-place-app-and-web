import 'package:demandium/components/custom_text_form_field.dart';
import 'package:demandium/components/text_field_title.dart';
import 'package:demandium/components/core_export.dart';
import 'package:demandium/feature/create_post/widget/additional_instruction_dialog.dart';
import 'package:demandium/feature/create_post/widget/subcategory_service_view.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

class CreatePostScreen extends StatefulWidget {
  final String schedule;
  const CreatePostScreen({Key? key, required this.schedule}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {

  late JustTheController tooltipController;
  @override
  void initState() {
    super.initState();
    Get.find<CategoryController>().getCategoryList(1,false);
    tooltipController = JustTheController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer :ResponsiveHelper.isDesktop(context) ? const MenuDrawer():null,
      appBar: CustomAppBar(title: "create_post".tr, isBackButtonExist: true,),
      body: FooterBaseView(
        child: WebShadowWrap(
          child: GetBuilder<CategoryController>(builder: (categoryController){
            return GetBuilder<CreatePostController>(
                builder: (createPostController){
                  return Padding( padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

                      const AddressInformation(
                        isFromCreatePostPage: true,
                      ),

                      TextFieldTitle(title: "service_category".tr,requiredMark: true),
                      Container(width: Get.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                            border: Border.all(color: Theme.of(context).disabledColor,width: 1)
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(

                              dropdownColor: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(5), elevation: 2,
                              onTap: (){
                                createPostController.updateSelectedService(null);
                              },

                              hint: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                                child: Text(createPostController.selectedCategoryName==''?
                                "select_category".tr:createPostController.selectedCategoryName,
                                  style: ubuntuRegular.copyWith(
                                      color: createPostController.selectedCategoryName==''?
                                      Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.6):
                                      Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.8)
                                  ),
                                ),
                              ),
                              icon: const Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                                child: Icon(Icons.keyboard_arrow_down),
                              ),
                              items:categoryController.categoryList?.map((CategoryModel items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Row(
                                    children: [
                                      Text(items.name??"",
                                        style: ubuntuRegular.copyWith(
                                          color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (CategoryModel? newValue) {
                                createPostController.selectCategory(newValue?.id??"");
                                showModalBottomSheet(
                                    useRootNavigator: true,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    context: context, builder: (context) => SubcategoryServiceView (categoryId: newValue?.id??"",));
                              }
                          ),
                        ),
                      ),
                      if(createPostController.selectedService!=null)
                        Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                          TextFieldTitle(title: "service".tr,requiredMark: false),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.05),
                              border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            ),
                            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            child: Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                child: CustomImage(image: '${Get.find<SplashController>().configModel.content!.imageBaseUrl!}/service/${createPostController.selectedService!.thumbnail}',
                                  height: 50,width: 50,),
                              ),
                              SizedBox(width: Dimensions.fontSizeLarge,),
                              Text(createPostController.selectedService!.name??"",style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge),)
                            ],),),
                        ],
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      Column(children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
                              TextFieldTitle(title: "provide_service_description".tr,requiredMark: false),
                              JustTheTooltip(
                                backgroundColor: Theme.of(context).primaryColorDark,
                                controller: tooltipController,
                                preferredDirection: AxisDirection.up,
                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusExtraLarge)),
                                tailLength: 14,
                                tailBaseWidth: 20,

                                content: Padding(
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                  child:  Column(mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text("create_service_request_instruction".tr,
                                      textAlign: TextAlign.center,
                                      style: ubuntuRegular.copyWith(color: Colors.white.withOpacity(0.7))
                                    ),
                                  ]),
                                ),
                                child: IconButton(
                                  onPressed: (){
                                    tooltipController.showTooltip();
                                  },
                                  icon: Icon(Icons.info_outline,color: Theme.of(context).colorScheme.primary,size: 18),
                                ),
                              )
                            ]),

                          ],
                        ),

                        CustomTextFormField(
                          outlineInputBorderRadius: Dimensions.paddingSizeExtraSmall,
                          hintText: "",
                          inputType: TextInputType.text,
                          outlineInputBorderColor: Theme.of(context).hintColor,
                          maxLines: 5,
                          controller: createPostController.descriptionController,
                          isShowBorder: true,
                        ),
                      ]),

                      if(createPostController.additionalInstruction.isNotEmpty)
                        ListView.builder(itemBuilder: (context,index){
                          return Container(decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                            border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),),
                            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                            margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start,children: [
                              Flexible(child: Text(createPostController.additionalInstruction[index],style: ubuntuRegular.copyWith(color: Theme.of(context).colorScheme.primary),)),

                              const SizedBox(width: Dimensions.paddingSizeDefault,),
                              GestureDetector(
                                onTap: ()=> createPostController.removeAdditionalInstruction(index),
                                child: Container(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                                  padding: const EdgeInsets.all(2),
                                  child: Center(child: Icon(
                                    Icons.close,color: Theme.of(context).colorScheme.primary, size: 12,
                                  ),),
                                ),
                              )
                            ],),
                          );
                        },
                          itemCount: createPostController.additionalInstruction.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                        ),

                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                      GestureDetector(
                        onTap: () => showDialog(
                            context: context, builder: (BuildContext context){
                          return const AdditionalInstructionDialog(
                          );
                        }).then((value) => createPostController.additionalInstructionController.text = ''),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                          Text(createPostController.selectedService !=null ?
                          'add_additional_instruction'.tr : 'add_any_specific_requests_here'.tr,
                            style:  ubuntuRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).colorScheme.primary
                          ),),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                          Container(
                              color: Theme.of(context).primaryColor.withOpacity(0.2),
                              child: Icon(Icons.add,color: Theme.of(context).colorScheme.primary,size: 20,)),
                        ],),
                      ),
                      SizedBox(height: Get.height*0.1,),

                      if(ResponsiveHelper.isDesktop(context))
                        createPostController.isLoading? const Center(child: CircularProgressIndicator()) : CustomButton(
                          buttonText: ""
                              "create_post".tr,
                          height: ResponsiveHelper.isDesktop(context)? 50 : 40,
                          width: 200,
                          radius: Dimensions.radiusExtraMoreLarge,
                          onPressed: (){
                            _createPost(createPostController);
                          },
                        ),
                    ],),
                  );
                });
          }),
        ),
      ),
      bottomSheet: !ResponsiveHelper.isDesktop(context)? GetBuilder<CreatePostController>(builder: (createPostController){
        return Container(
          height: 55,
          width: Get.width,
          decoration: BoxDecoration(
              boxShadow: kElevationToShadow[1],
            color: Theme.of(context).cardColor
          ),
          child: createPostController.isLoading?
          const Center(child: CircularProgressIndicator()) :
          CustomButton(
            buttonText: "create_post".tr,
            height: 40,
            width: 200,
            radius: Dimensions.radiusExtraMoreLarge,
            onPressed: (){
              _createPost(createPostController);

            },
          ),

        );
      }):const SizedBox(),
    );
  }

  void _createPost(CreatePostController  createPostController) {
    AddressModel? addressModel = Get.find<LocationController>().selectedAddress ?? Get.find<LocationController>().getUserAddress();

    if(addressModel == null){
      customSnackBar('add_address_first'.tr);
    } else if((addressModel.contactPersonName == "null" || addressModel.contactPersonName == null || addressModel.contactPersonName!.isEmpty) || (addressModel.contactPersonNumber=="null" || addressModel.contactPersonNumber == null || addressModel.contactPersonNumber!.isEmpty)){
      customSnackBar("please_input_contact_person_name_and_phone_number".tr);
    }
    else if(createPostController.selectedService==null){
      customSnackBar("select_your_desired_service".tr);
    }else if(createPostController.descriptionController.text.isEmpty){
      customSnackBar("enter_service_description".tr);
    }else{
      createPostController.createCustomPost(widget.schedule, serviceAddress: addressModel);
    }
  }
}
