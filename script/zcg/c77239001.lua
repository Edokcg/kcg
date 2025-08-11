--圣结界的女巫
function c77239001.initial_effect(c)
    c:EnableReviveLimit()
    --special summon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c77239001.sprcon)
    e2:SetOperation(c77239001.sprop)
    c:RegisterEffect(e2)
	
	--不受影响
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c77239001.efilter)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	c:RegisterEffect(e3)
	
	--增加属性
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_ADD_ATTRIBUTE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(ATTRIBUTE_EARTH+ATTRIBUTE_WATER+ATTRIBUTE_FIRE+ATTRIBUTE_WIND+ATTRIBUTE_DARK)
	c:RegisterEffect(e4)
	
    --增加类型
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetCode(EFFECT_ADD_TYPE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetValue(TYPE_NORMAL+TYPE_EFFECT+TYPE_FUSION+TYPE_RITUAL+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM)
    c:RegisterEffect(e5)
	
	--破坏对方3张卡
	local e7=Effect.CreateEffect(c)	
	e7:SetDescription(aux.Stringid(77239001,0))
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
    e7:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e7:SetCondition(c77239001.condition7)
	e7:SetTarget(c77239001.target7)
	e7:SetOperation(c77239001.activate7)
	c:RegisterEffect(e7)
	
	--1000点伤害
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(77239001,1))
	e8:SetCategory(CATEGORY_DAMAGE)
	e8:SetType(EFFECT_TYPE_IGNITION)
    e8:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(c77239001.condition7)
	e8:SetTarget(c77239001.target8)
	e8:SetOperation(c77239001.operation8)
	c:RegisterEffect(e8)
	
	--从对方卡组选择1张卡加入手牌
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(77239001,2))
	e9:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e9:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCondition(c77239001.condition7)
	e9:SetTarget(c77239001.target9)
	e9:SetOperation(c77239001.activate9)
	c:RegisterEffect(e9)
	
	--对方从卡组送10张卡去墓地
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(77239001,3))
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetCategory(CATEGORY_DECKDES)
	e10:SetRange(LOCATION_MZONE)
    e10:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e10:SetCondition(c77239001.condition7)
	e10:SetTarget(c77239001.distg10)
	e10:SetOperation(c77239001.disop10)
	c:RegisterEffect(e10)
	
	--特殊召唤
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(77239001,4))
	e11:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e11:SetCondition(c77239001.condition7)
	e11:SetTarget(c77239001.target11)
	e11:SetOperation(c77239001.operation11)
	c:RegisterEffect(e11)
end
-----------------------------------------------------------------------
function c77239001.spcfilter(c)
    return c:IsFaceup() or c:IsFacedown()
end
function c77239001.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-3
        and Duel.IsExistingMatchingCard(c77239001.spcfilter,tp,LOCATION_MZONE,0,3,nil)
		and Duel.IsExistingMatchingCard(c77239001.cfilter7,tp,LOCATION_ONFIELD,0,1,nil)
end
function c77239001.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c77239001.spcfilter,tp,LOCATION_MZONE,0,3,3,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
------------------------------------------------------------------------
function c77239001.efilter(e,re)
	return re:IsActiveType(TYPE_TRAP+TYPE_SPELL+TYPE_MONSTER) and e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
------------------------------------------------------------------------
function c77239001.cfilter7(c)
	return c:IsFaceup() and c:IsCode(77239000)
end
function c77239001.condition7(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c77239001.cfilter7,tp,LOCATION_ONFIELD,0,1,nil)
end
function c77239001.filter7(c)
	return c:IsDestructable()
end
function c77239001.target7(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c77239001.filter7(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c77239001.filter7,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c77239001.filter7,tp,0,LOCATION_ONFIELD,1,3,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77239001.activate7(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    Duel.Destroy(g,REASON_EFFECT)
end
--------------------------------------------------------------------------
function c77239001.target8(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c77239001.operation8(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
--------------------------------------------------------------------------
function c77239001.target9(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_DECK,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77239001.activate9(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local rg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_DECK,nil)
    if rg:GetCount()>0 then
        Duel.ConfirmCards(tp,rg)
        local tg=Group.CreateGroup()               
        local tc=rg:Select(tp,1,1,nil):GetFirst()
        rg:Remove(Card.IsCode,nil,tc:GetCode())
        tg:AddCard(tc)
        Duel.SendtoHand(tc,tp,REASON_EFFECT)               
    end	
end
------------------------------------------------------------------------
function c77239001.distg10(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,10)
end
function c77239001.disop10(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.DiscardDeck(1-tp,10,REASON_EFFECT)
end
------------------------------------------------------------------------
function c77239001.filter11(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239001.target11(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77239001.filter11,tp,LOCATION_DECK,LOCATION_DECK,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c77239001.operation11(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local b1=Duel.IsExistingMatchingCard(c77239001.filter11,tp,LOCATION_DECK,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c77239001.filter11,tp,0,LOCATION_DECK,1,nil,e,tp) 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not (b1 or b2) then return end
	    local ops={}
	    local opval={}
	    local off=1
	    if b1 then
		ops[off]=aux.Stringid(77239001,5)
		opval[off-1]=1
		off=off+1
	    end
	    if b2 then
		ops[off]=aux.Stringid(77239001,6)
		opval[off-1]=2
		off=off+1
	    end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	    if opval[op]==1 then
		    local g=Duel.SelectMatchingCard(tp,c77239001.filter11,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
		else
		    local rg=Duel.GetMatchingGroup(c77239001.filter11,tp,0,LOCATION_DECK,nil,e,tp)
		    Duel.ConfirmCards(tp,rg)
		    local tc=rg:Select(tp,1,1,nil)
		    Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
    end
end
-----------------------------------------------------------------------



