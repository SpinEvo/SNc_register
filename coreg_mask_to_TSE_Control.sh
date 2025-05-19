path="/home3/HWGroup/lihw/Research/ZS-PD/PD-NM/data/nifti/NM-MRI/Control"
for dir in "$path"/*
do
    cd $dir;
	# Step-1
	antsRegistrationSyN.sh -d 3 -f T1.nii -m hw_average_nonlin_10_synthsr.nii -t 'r' -o step1_rigid_t2a_;
	antsApplyTransforms -d 3 -i hw_SN_ROI.nii -o step1_rigid_t2a_SN_mask.nii -r T1.nii -t step1_rigid_t2a_0GenericAffine.mat -n GenericLabel;
	antsApplyTransforms -d 3 -i hw_BND_ROI.nii -o step1_rigid_t2a_BND_mask.nii -r T1.nii -t step1_rigid_t2a_0GenericAffine.mat -n GenericLabel;
	printf "\n#### Finished Step-1 ####\n";
	# Step-2
	antsRegistrationSyN.sh -d 3 -f T1.nii -m step1_rigid_t2a_Warped.nii.gz -o step2_;
	antsApplyTransforms -d 3 -i step1_rigid_t2a_SN_mask.nii -o step2_step1_rigid_t2a_SN_mask.nii -r T1.nii -t step2_1Warp.nii.gz -t step2_0GenericAffine.mat -n GenericLabel;
    antsApplyTransforms -d 3 -i step1_rigid_t2a_BND_mask.nii -o step2_step1_rigid_t2a_BND_mask.nii -r T1.nii -t step2_1Warp.nii.gz -t step2_0GenericAffine.mat -n GenericLabel;
	antsApplyTransforms -d 3 -i step1_rigid_t2a_Warped.nii.gz -o step2_step1_rigid_t2a_template.nii -r T1.nii -t step2_1Warp.nii.gz -t step2_0GenericAffine.mat;
	printf "\n#### Finished Step-2 ####\n";
	# Step-3
	antsRegistrationSyN.sh -d 3 -f TSE.nii -m T1.nii -t 'r' -o T12TSE_;
	antsApplyTransforms -d 3 -i step2_step1_rigid_t2a_SN_mask.nii -o SN_mask_TSE_space.nii -r TSE.nii -t T12TSE_0GenericAffine.mat -n GenericLabel;
	antsApplyTransforms -d 3 -i step2_step1_rigid_t2a_BND_mask.nii -o BND_mask_TSE_space.nii -r TSE.nii -t T12TSE_0GenericAffine.mat -n GenericLabel;
	printf "\n#### Finished Step-3 ####\n";
    cd /home3/HWGroup/lihw/Research/ZS-PD/PD-NM/code;
	printf "\n######## Finished %s ########\n" $dir;
done
printf "\n#### All jobs done ####\n";