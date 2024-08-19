filter Test-IsNotNullOrEmpty {
    <#
        .SYNOPSIS
        Test if an object is not null or empty

        .DESCRIPTION
        Test if an object is not null or empty

        .EXAMPLE
        '' | Test-IsNotNullOrEmpty

        False
    #>
    [OutputType([bool])]
    [Cmdletbinding()]
    [Alias('IsNotNullOrEmpty')]
    param(
        # Object to test
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [AllowNull()]
        [object] $Object
    )
    return -not ($Object | IsNullOrEmpty)

}
