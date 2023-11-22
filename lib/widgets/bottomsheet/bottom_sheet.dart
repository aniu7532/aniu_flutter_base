// ignore_for_file: always_declare_return_types, type_annotate_public_apis

import 'package:flutter/material.dart';
import 'package:zzerp/app/myapp.dart';
import 'package:zzerp/app/zz_icon.dart';
import 'package:zzerp/base/bill_base/enum/bill_type.dart';
import 'package:zzerp/const/app_pms.dart';
import 'package:zzerp/gen/colors.gen.dart';

mixin Musical {
  bool canPlayPiano = false;
  bool canCompose = false;
  bool canConduct = false;

  void entertainMe() {
    if (canPlayPiano) {
      print('Playing piano');
    } else if (canConduct) {
      print('Waving hands');
    } else {
      print('Humming to self');
    }
  }
}

///弹出底部弹窗Util
class BottomSheetUtil {
  ///弹出底部弹窗Widget
  static showBottomSheetWidget({
    required BuildContext context,
    required BottomSheetType sheetType,
    int? saleStatus,
    int? status,
    ValueChanged<BottomSheetItemType>? callBack,
  }) {
    final operationButtons = _getItemTypes(
      sheetType: sheetType,
      saleStatus: saleStatus,
      status: status,
    );
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 290,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 12),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                    ),
                    itemCount: operationButtons.length,
                    itemBuilder: (context, index) {
                      return _operationButton(context, operationButtons[index],
                          saleStatus, callBack);
                    },
                  ),
                ),
              ),
              Container(
                  width: double.infinity, height: 10, color: Colors.grey[200]),
              // 取消按钮
              InkWell(
                onTap: appRouter.pop,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  alignment: Alignment.center,
                  child: const Text(
                    '取消',
                    style: TextStyle(
                      fontSize: 18,
                      color: ColorName.normalTxtColor,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  ///获取所有item类型
  static List<BottomSheetItemType> _getItemTypes({
    required BottomSheetType sheetType,
    int? saleStatus,
    int? status,
  }) {
    final operationButton = <BottomSheetItemType>[];
    // '开单', '退货', '收款', '编辑', '销售记录', '删除'
    if (sheetType == BottomSheetType.customer) {
      if (appPms.haveSaleBillPms(BillType.ORDER_OUTBOUND, OpType.add)) {
        operationButton.add(BottomSheetItemType.customerOpenBill);
      }
      if (appPms.haveSaleBillPms(BillType.ORDER_RETURN, OpType.add)) {
        operationButton.add(BottomSheetItemType.customerReturnGoods);
      }
      if (appPms.haveSaleBillPms(BillType.RECEIPT, OpType.add)) {
        operationButton.add(BottomSheetItemType.customerCollectMoney);
      }
      if (appPms.haveCusPms(OpType.modify)) {
        operationButton.add(BottomSheetItemType.customerEdit);
      }
      operationButton.add(BottomSheetItemType.customerSaleRecord);
      if (appPms.haveCusPms(OpType.delete)) {
        operationButton.add(BottomSheetItemType.customerDelete);
      }
    } else if (sheetType == BottomSheetType.goods) {
      // '编辑','复制'，'调价格' '调库存' '标签'  '下架' '停用' '删除'
      operationButton.clear();

      if (appPms.haveGoodsPms(OpType.modify)) {
        operationButton.add(
          BottomSheetItemType.goodsEdit,
        );
      }

      if (appPms.haveGoodsPms(OpType.add)) {
        operationButton.add(BottomSheetItemType.goodsCopy);
      }

      if (appPms.haveGoodsPms(OpType.modify)) {
        //调价格
        //1、该功能需要受到商品编辑权限控制；
        operationButton.add(BottomSheetItemType.goodsEditPrice);
      }

      if (appPms.haveGoodsPms(OpType.modify)) {
        operationButton.add(
          BottomSheetItemType.goodsStock,
        );
      }
      if (appPms.haveGoodsPms(OpType.modify)) {
        operationButton.add(
          BottomSheetItemType.goodsTag,
        );
      }
      if (appPms.haveGoodsPms(OpType.modify)) {
        // 启用
        if (status == 1) {
          //销售状态(0：下架，1：上架)
          if (saleStatus == 0) {
            operationButton.add(BottomSheetItemType.goodsOffShelfPut);
          } else if (saleStatus == 1) {
            operationButton.add(BottomSheetItemType.goodsOffShelfDown);
          }
        }
      }

      if (appPms.haveGoodsPms(OpType.modify)) {
        //  status == 1 为启用状态
        if (status == 1) {
          operationButton.add(BottomSheetItemType.goodsDisable);
        } else {
          operationButton.add(BottomSheetItemType.goodsEnable);
        }
      }

      if (appPms.haveGoodsPms(OpType.delete)) {
        operationButton.add(BottomSheetItemType.goodsDelete);
      }
    } else if (sheetType == BottomSheetType.supplier) {
      // 采购单、采购退货单、付款单、历史单据、编辑、删除
      operationButton.clear();
      if (appPms.haveSaleBillPms(BillType.PURCHASE_ORDER, OpType.add)) {
        operationButton.add(BottomSheetItemType.supplierOpenBill);
      }
      if (appPms.haveSaleBillPms(BillType.PURCHASE_RETURN, OpType.add)) {
        operationButton.add(BottomSheetItemType.supplierReturnGoods);
      }
      if (appPms.haveSaleBillPms(BillType.PAYMENT, OpType.add)) {
        operationButton.add(BottomSheetItemType.supplierPayMoney);
      }
      if (appPms.haveBillViewPms()) {
        operationButton.add(BottomSheetItemType.supplierBillCenter);
      }
      if (appPms.haveSupPms(OpType.modify)) {
        operationButton.add(BottomSheetItemType.supplierEdit);
      }
      if (appPms.haveSupPms(OpType.delete)) {
        operationButton.add(BottomSheetItemType.supplierDelete);
      }
    } else {}
    return operationButton;
  }

  ///底部弹窗的操作按钮
  static Widget _operationButton(
    BuildContext context,
    BottomSheetItemType sheetType,
    int? saleStatus,
    ValueChanged<BottomSheetItemType>? callBack,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        callBack?.call(sheetType);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: sheetType.bgColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              sheetType.icon,
              size: 20,
              color: const Color(0xFF111A34),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            sheetType.name,
            style: const TextStyle(
              fontSize: 14,
              color: ColorName.txtColor41485d,
            ),
          ),
        ],
      ),
    );
  }
}

///底部弹出框操作按钮类型
class BottomSheetItemType {
  const BottomSheetItemType._(this.name, this.icon, this.bgColor);

  ///名称
  final String name;

  ///图标
  final IconData icon;

  ///背景圆圈颜色
  final Color bgColor;

  ///客户开单
  static const BottomSheetItemType customerOpenBill = BottomSheetItemType._(
    '开单',
    ZzIcons.icon_dingdan,
    ColorName.bgColor,
  );

  ///客户退货
  static const BottomSheetItemType customerReturnGoods = BottomSheetItemType._(
    '退货',
    ZzIcons.icon_tuihuo,
    ColorName.bgColor,
  );

  ///客户收款
  static const BottomSheetItemType customerCollectMoney = BottomSheetItemType._(
    '收款',
    ZzIcons.icon_shoukuan,
    ColorName.bgColor,
  );

  ///客户编辑
  static const BottomSheetItemType customerEdit = BottomSheetItemType._(
    '编辑',
    ZzIcons.icon_bianji,
    ColorName.bgColor,
  );

  ///供应商编辑
  static const BottomSheetItemType supplierEdit = BottomSheetItemType._(
    '编辑',
    ZzIcons.icon_bianji,
    ColorName.bgColor,
  );

  ///客户销售记录
  static const BottomSheetItemType customerSaleRecord = BottomSheetItemType._(
    '销售记录',
    ZzIcons.icon_chakandanju,
    ColorName.bgColor,
  );

  ///客户删除
  static const BottomSheetItemType customerDelete = BottomSheetItemType._(
    '删除',
    ZzIcons.icon_shanchu2,
    ColorName.bgColor,
  );

  ///商品调价格
  static const BottomSheetItemType goodsEditPrice = BottomSheetItemType._(
    '调价格',
    ZzIcons.icon_tiaojiage2,
    ColorName.bgColor,
  );

  ///商品 启用
  static const BottomSheetItemType goodsEnable = BottomSheetItemType._(
    '启用',
    ZzIcons.icon_qiyong,
    ColorName.bgColor,
  );

  ///商品 停用
  static const BottomSheetItemType goodsDisable = BottomSheetItemType._(
    '停用',
    ZzIcons.icon_tingyong,
    ColorName.bgColor,
  );

  ///商品删除
  static const BottomSheetItemType goodsDelete = BottomSheetItemType._(
    '删除',
    ZzIcons.icon_shanchu2,
    ColorName.bgColor,
  );

  ///供应商删除
  static const BottomSheetItemType supplierDelete = BottomSheetItemType._(
    '删除',
    ZzIcons.icon_shanchu2,
    ColorName.bgColor,
  );

  ///商品复制
  static const BottomSheetItemType goodsCopy = BottomSheetItemType._(
    '复制',
    ZzIcons.icon_fuzhi2,
    ColorName.bgColor,
  );

  ///商品编辑
  static const BottomSheetItemType goodsEdit = BottomSheetItemType._(
    '编辑',
    ZzIcons.icon_bianji,
    ColorName.bgColor,
  );

  ///商品调库存
  static const BottomSheetItemType goodsStock = BottomSheetItemType._(
    '调库存',
    ZzIcons.icon_tiaokucun1,
    ColorName.bgColor,
  );

  ///商品上架 销售状态(0：下架，1：上架)
  static const BottomSheetItemType goodsOffShelfPut = BottomSheetItemType._(
    '上架',
    ZzIcons.icon_shangjia,
    ColorName.bgColor,
  );

  ///商品下架 销售状态(0：下架，1：上架)
  static const BottomSheetItemType goodsOffShelfDown = BottomSheetItemType._(
    '下架',
    ZzIcons.icon_xiajia,
    ColorName.bgColor,
  );

  ///商品标签
  static const BottomSheetItemType goodsTag = BottomSheetItemType._(
    '标签',
    ZzIcons.icon_biaoqian2,
    ColorName.bgColor,
  );

  ///供应商开采购单
  static const BottomSheetItemType supplierOpenBill = BottomSheetItemType._(
    '采购',
    ZzIcons.icon_dingdan,
    ColorName.bgColor,
  );

  ///供应商退货
  static const BottomSheetItemType supplierReturnGoods = BottomSheetItemType._(
    '退货',
    ZzIcons.icon_tuihuo,
    ColorName.bgColor,
  );

  ///供应商付款
  static const BottomSheetItemType supplierPayMoney = BottomSheetItemType._(
    '付款',
    ZzIcons.icon_shoukuan,
    ColorName.bgColor,
  );

  ///单据中心
  static const BottomSheetItemType supplierBillCenter = BottomSheetItemType._(
    '历史单据',
    ZzIcons.icon_chakandanju,
    ColorName.bgColor,
  );
}

enum BottomSheetType {
  // 客户
  customer,
  // 商品
  goods,
  // 供应商
  supplier,
}
