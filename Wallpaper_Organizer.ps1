#Alex O'Connor
#1/23/2015
#Semi-Automate organizing wallpapers based on resolution

#Renames all files in the directory given
function RenameFiles( $dirname ){

	$i=0;
    $NumFiles = (Get-ChildItem $dirname | Measure-Object).count
	
	Get-ChildItem $dirname | Foreach-object{
	   #Check to see if name/number is already being used
	   if( $i -ne $_.BaseName ){
			Rename-Item -Path $_.FullName -Force -NewName ( ( ( ($i).tostring("000") ).padleft( ( $_.count.tostring() ).length) ) + $_.extension);
	   }
	   $i++
	}
	Write-Host "$dirname files renamed..."
}

Clear-Host

$ScriptName = $MyInvocation.MyCommand.Name

$GIF='D:\My Pictures\GIF'
$1080='D:\My Pictures\1920x1080'
$1200='D:\My Pictures\1920x1200'
$HDplus='D:\My Pictures\HD+'
$HDminus='D:\My Pictures\HD-'
$Other='D:\My Pictures\Other'

#Write-Host "SCRIPTNAME = '$ScriptName'"
Get-ChildItem $PWD | Foreach-object{
	if( "$_" -eq "$ScriptName" ){
		#Write-Host "This Script..."
	}elseif( !(Test-Path -PathType Container $_) ){
        Write-Host $_

        $image = New-Object -comObject WIA.ImageFile
	    $image.LoadFile( $_.FullName )
	    $width = $image.Width
	    $height = $image.Height
	    
	    if( $width -eq 1920 -and $height -eq 1080 ){	
		    Write-Host $_.FullName "-" $width"x"$height
		    mv -Force $_.FullName $1080
	    }elseif( $width -eq 1920 -and $height -eq 1200 ){
		    Write-Host $_.FullName "-" $width"x"$height
		    mv -Force $_.FullName $1200	
	    }elseif( $width -gt 1920 -and $height -ge 1080 ){
		    Write-Host $_.FullName "-" $width"x"$height
		    mv -Force $_.FullName $HDplus
	    }elseif( $width -lt 1920 -and $height -lt 1080 ){
		    Write-Host $_.FullName "-" $width"x"$height
		    mv -Force $_.FullName $HDminus
	    }elseif( $_ -eq ".gif" ){
            mv -Force $_.FullName $GIF
        }else{ mv -Force $_.FullName $Other }
    }#else{ Write-Host $_ = DIRECTORY }
}

RenameFiles( $1080 );
RenameFiles( $1200 );
RenameFiles( $HDminus );
RenameFiles( $HDplus );
RenameFiles( $Other );
RenameFiles( $GIF );
Write-Host `n
