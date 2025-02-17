# vim: syntax=python tabstop=4 expandtab
# coding: utf-8

__author__ = "Jonas Almlöf"
__copyright__ = "Copyright 2021, Jonas Almlöf"
__email__ = "jonas.almlof@scilifelab.uu.se"
__license__ = "GPL-3"


rule gatk_cnv_call_copy_ratio_segments:
    input:
        "cnv_sv/gatk_cnv_model_segments/{sample}_{type}.clean.cr.seg",
    output:
        segments=temp("cnv_sv/gatk_cnv_call_copy_ratio_segments/{sample}_{type}.clean.calledCNVs.seg"),
        igv_segments=temp("cnv_sv/gatk_cnv_call_copy_ratio_segments/{sample}_{type}.clean.calledCNVs.igv.seg"),
    params:
        extra=config.get("gatk_cnv_call_copy_ratio_segments", {}).get("extra", ""),
    log:
        "cnv_sv/gatk_cnv_call_copy_ratio_segments/{sample}_{type}.clean.calledCNVs.seg.log",
    benchmark:
        repeat(
            "cnv_sv/gatk_cnv_call_copy_ratio_segments/{sample}_{type}.clean.calledCNVs.seg.benchmark.tsv",
            config.get("gatk_cnv_call_copy_ratio_segments", {}).get("benchmark_repeats", 1),
        )
    threads: config.get("gatk_cnv_call_copy_ratio_segments", {}).get("threads", config["default_resources"]["threads"])
    resources:
        threads=config.get("gatk_cnv_call_copy_ratio_segments", {}).get("threads", config["default_resources"]["threads"]),
        time=config.get("gatk_cnv_call_copy_ratio_segments", {}).get("time", config["default_resources"]["time"]),
        mem_mb=config.get("gatk_cnv_call_copy_ratio_segments", {}).get("mem_mb", config["default_resources"]["mem_mb"]),
        mem_per_cpu=config.get("gatk_cnv_call_copy_ratio_segments", {}).get(
            "mem_per_cpu", config["default_resources"]["mem_per_cpu"]
        ),
        partition=config.get("gatk_cnv_call_copy_ratio_segments", {}).get("partition", config["default_resources"]["partition"]),
    container:
        config.get("gatk_cnv_call_copy_ratio_segments", {}).get("container", config["default_container"])
    conda:
        "../envs/gatk_cnv_call_copy_ratio_segments.yaml"
    message:
        "{rule}: Use gatk_cnv to obtain cnv_sv/gatk_cnv_call_copy_ratio_segments/{wildcards.sample}_{wildcards.type}.clean.calledCNVs.seg"
    shell:
        "(gatk --java-options '-Xmx4g' CallCopyRatioSegments "
        "--input {input} "
        "--output {output.segments} "
        "{params.extra}) &> {log}"
