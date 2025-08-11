-- 狱火机·自定义融合怪兽
-- 设置卡片属性
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	-- 融合材料
	Fusion.AddProcMixRep(c,true,true,aux.FilterBoolFunctionEx(Card.IsSetCard,0xbb),1,99,60551528,58446973)

	-- 效果①：攻击力上升
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)

	-- 效果②：无效并破坏
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.negcon)
	e2:SetTarget(s.negtg)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)

	-- 效果③：破坏送墓的场合，检索「炼狱」卡
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)

	-- 效果④：11星怪兽保护效果
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(s.indtg)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e5)
end
s.listed_series={0xbb}
s.material_setcode=0xbb
-- 融合材料过滤函数
function s.fusfilter(c)
	return c:IsSetCard(0xbb) and c:IsType(TYPE_MONSTER) -- "狱火机"怪兽的卡片组代码为0x12b
end

-- 效果①：攻击力上升
function s.atkval(e,c)
	return c:GetMaterialCount()*500
end

-- 效果②：无效并破坏的发动条件
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return Duel.IsChainNegatable(ev) and ep==1-tp
end


-- 效果②：无效并破坏的目标
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end

-- 效果②：无效并破坏的操作
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 and Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

-- 效果②：选择回卡组的「狱火机」怪兽
function s.cfilter(c)
	return c:IsSetCard(0xbb) and c:IsAbleToDeck()
end

-- 效果③：触发条件
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end

-- 效果③：选择目标
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end

-- 效果③：操作
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

-- 效果③：检索「炼狱」卡过滤函数
function s.thfilter(c)
	return c:IsSetCard(0xc5) and c:IsAbleToHand() -- "炼狱"的卡片组代码为0x9c
end

-- 效果④：11星怪兽的保护
function s.indtg(e,c)
	return c:IsLevel(11)
end
