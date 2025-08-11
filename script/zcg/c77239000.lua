--绝对魔法圣结界
function c77239000.initial_effect(c)
	--发动效果
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)	
	c:RegisterEffect(e1)

	--不受影响
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c77239000.efilter)	
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetCondition(c77239000.condition)	
	c:RegisterEffect(e2)
	
	--1回合1次不会战斗破坏
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCountLimit(1)
	e3:SetCondition(c77239000.condition)	
	e3:SetValue(c77239000.valcon)
	c:RegisterEffect(e3)
	
	--通常怪兽：破坏对方一只怪兽
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77239000,0))
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)	
	e4:SetCondition(c77239000.condition4)	
	e4:SetTarget(c77239000.destg)
	e4:SetOperation(c77239000.desop)
	c:RegisterEffect(e4)
	
	--效果怪兽：破坏对方一张魔法、陷阱卡
	local e5=Effect.CreateEffect(c)	
	e5:SetDescription(aux.Stringid(77239000,1))	
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)	
	e5:SetCondition(c77239000.condition5)		
	e5:SetTarget(c77239000.target5)
	e5:SetOperation(c77239000.activate5)
	c:RegisterEffect(e5)
	
	--融合怪兽：丢弃对方一张手牌
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(77239000,2))		
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetCategory(CATEGORY_HANDES)
    e6:SetRange(LOCATION_FZONE)
    e6:SetCountLimit(1)
	e6:SetCondition(c77239000.condition6)
	e6:SetTarget(c77239000.hdtg6)
	e6:SetOperation(c77239000.hdop6)
	c:RegisterEffect(e6)
	
	--仪式怪兽：破坏对方一张卡
	local e7=Effect.CreateEffect(c)	
	e7:SetDescription(aux.Stringid(77239000,3))		
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCountLimit(1)	
	e7:SetCondition(c77239000.condition7)		
	e7:SetTarget(c77239000.target7)
	e7:SetOperation(c77239000.activate7)
	c:RegisterEffect(e7)	
	
    --同调怪兽：对方卡组最上方1张卡送墓地
    local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(77239000,4))	
    e8:SetCategory(CATEGORY_DECKDES)
    e8:SetType(EFFECT_TYPE_IGNITION)
    e8:SetRange(LOCATION_FZONE)
    e8:SetCountLimit(1)
    e8:SetCondition(c77239000.condition8)
    e8:SetTarget(c77239000.settg8)
    e8:SetOperation(c77239000.setop8)
    c:RegisterEffect(e8)
	
	--风：自己怪兽攻击力上升500
    local e9=Effect.CreateEffect(c)	
    e9:SetType(EFFECT_TYPE_FIELD)
    e9:SetRange(LOCATION_FZONE)
    e9:SetCode(EFFECT_UPDATE_ATTACK)
    e9:SetTargetRange(LOCATION_MZONE,0)
	e9:SetCondition(c77239000.atkcon9)
    e9:SetValue(500)
    c:RegisterEffect(e9)
	
	--水：对方怪兽攻击力下降500
    local e10=Effect.CreateEffect(c)	
    e10:SetType(EFFECT_TYPE_FIELD)
    e10:SetRange(LOCATION_FZONE)
    e10:SetCode(EFFECT_UPDATE_ATTACK)
    e10:SetTargetRange(0,LOCATION_MZONE)
	e10:SetCondition(c77239000.atkcon10)
    e10:SetValue(-500)
    c:RegisterEffect(e10)
	
	--炎：每只怪兽回复400点
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(77239000,5))
	e11:SetCategory(CATEGORY_RECOVER)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e11:SetRange(LOCATION_FZONE)
	e11:SetCountLimit(1)
	e11:SetCondition(c77239000.condition11)
	e11:SetTarget(c77239000.target11)
	e11:SetOperation(c77239000.operation11)
	c:RegisterEffect(e11)
	
	--地：每只怪兽伤害400点
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(77239000,6))
	e12:SetCategory(CATEGORY_DAMAGE)
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e12:SetRange(LOCATION_FZONE)
	e12:SetCountLimit(1)
	e12:SetCondition(c77239000.condition12)
	e12:SetTarget(c77239000.target12)
	e12:SetOperation(c77239000.operation12)
	c:RegisterEffect(e12)
	
	--光：对方不能发动怪兽效果
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD)
    e13:SetCode(EFFECT_CANNOT_TRIGGER)
    e13:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e13:SetRange(LOCATION_FZONE)
    e13:SetTargetRange(0,0xa)
	e13:SetCondition(c77239000.condition13)	
    e13:SetTarget(c77239000.distg13)
    c:RegisterEffect(e13)
	
	--暗：攻击指定类型的怪兽
    local e14=Effect.CreateEffect(c)
    e14:SetType(EFFECT_TYPE_FIELD)
    e14:SetRange(LOCATION_FZONE)
    e14:SetTargetRange(0,LOCATION_MZONE)
    e14:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e14:SetCondition(c77239000.condition14)	
    e14:SetValue(c77239000.atlimit14)
    c:RegisterEffect(e14)
	
	--存在魔法陷阱：对方效果发动无效并破坏
	local e15=Effect.CreateEffect(c)
	e15:SetDescription(aux.Stringid(77239000,7))	
	e15:SetType(EFFECT_TYPE_QUICK_O)
    e15:SetRange(LOCATION_FZONE)	
    e15:SetCode(EVENT_CHAINING)	
	e15:SetCountLimit(1)	
	e15:SetCondition(c77239000.condition15)
	e15:SetTarget(c77239000.target15)
	e15:SetOperation(c77239000.activate15)
	c:RegisterEffect(e15)
	
	--魔陷存在1张：从卡组选择1张魔陷加入手牌
	local e16=Effect.CreateEffect(c)
	e16:SetDescription(aux.Stringid(77239000,8))	
	e16:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e16:SetType(EFFECT_TYPE_IGNITION)
	e16:SetRange(LOCATION_FZONE)
	e16:SetCountLimit(1)	
    e16:SetTarget(c77239000.target16)
    e16:SetOperation(c77239000.activate16)
	c:RegisterEffect(e16)

	--魔陷存在2张：从对方卡组选1张卡送入墓地
	local e17=Effect.CreateEffect(c)
	e17:SetDescription(aux.Stringid(77239000,9))	
	e17:SetCategory(CATEGORY_DECKDES) 	
	e17:SetType(EFFECT_TYPE_IGNITION)
	e17:SetRange(LOCATION_FZONE)
    e17:SetCountLimit(1)
	e17:SetCondition(c77239000.condition17)		
	e17:SetTarget(c77239000.target17)
	e17:SetOperation(c77239000.activate17)
	c:RegisterEffect(e17)	
	
	--魔陷存在3张：持续公开手牌
	local e18=Effect.CreateEffect(c)
	e18:SetType(EFFECT_TYPE_FIELD)
	e18:SetCode(EFFECT_PUBLIC)
	e18:SetRange(LOCATION_FZONE)
	e18:SetTargetRange(0,LOCATION_HAND)
	e18:SetCondition(c77239000.condition18)	
	c:RegisterEffect(e18)

	--魔陷存在4张：从对方卡组选1张卡回到最上方
	local e19=Effect.CreateEffect(c)
	e19:SetDescription(aux.Stringid(77239000,10))	
    e19:SetType(EFFECT_TYPE_IGNITION)
    e19:SetRange(LOCATION_FZONE)
    e19:SetCountLimit(1)	
	e19:SetCondition(c77239000.condition19)		
    e19:SetTarget(c77239000.target19)
    e19:SetOperation(c77239000.activate19)
    c:RegisterEffect(e19)
	

	--魔陷存在5张：宣告对方卡组最上方种类	
    local e20=Effect.CreateEffect(c)
    e20:SetDescription(aux.Stringid(77239000,12))
    e20:SetCategory(CATEGORY_REMOVE)
    e20:SetType(EFFECT_TYPE_IGNITION)
    e20:SetRange(LOCATION_FZONE)
    e20:SetCountLimit(1)
	e20:SetCondition(c77239000.condition20)		
    e20:SetTarget(c77239000.target20)
    e20:SetOperation(c77239000.operation20)
    c:RegisterEffect(e20)	
	
	--魔陷存在6张：从卡组送5张卡去墓地
	local e21=Effect.CreateEffect(c)	
	e21:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e21:SetCategory(CATEGORY_DECKDES)
	e21:SetCode(EVENT_PHASE+PHASE_END)	
	e21:SetRange(LOCATION_FZONE)
	e21:SetCountLimit(1)
	e21:SetCondition(c77239000.discon21)
	e21:SetTarget(c77239000.distg21)
	e21:SetOperation(c77239000.disop21)
	c:RegisterEffect(e21)	
end
-----------------------------------------------------------------------------
function c77239000.efilter(e,re)
	return re:IsActiveType(TYPE_TRAP+TYPE_SPELL+TYPE_MONSTER) and e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c77239000.condition(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)>0
end
-----------------------------------------------------------------------------
function c77239000.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
----------------------------------------------------------------------------
function c77239000.cfilter4(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end
function c77239000.condition4(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c77239000.cfilter4,tp,LOCATION_MZONE,0,1,nil)
end
function c77239000.filter4(c)
	return c:IsDestructable()
end
function c77239000.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c77239000.filter4(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77239000.filter4,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c77239000.filter4,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c77239000.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
--------------------------------------------------------------------------
function c77239000.cfilter5(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c77239000.condition5(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c77239000.cfilter5,tp,LOCATION_MZONE,0,1,nil)
end
function c77239000.filter5(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c77239000.target5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c77239000.filter5(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c77239000.filter5,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c77239000.filter5,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c77239000.activate5(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
-------------------------------------------------------------------------
function c77239000.cfilter6(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION)
end
function c77239000.condition6(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c77239000.cfilter6,tp,LOCATION_MZONE,0,1,nil)
end
function c77239000.hdtg6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():ResetFlagEffect(77239000)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,1-tp,1)
end
function c77239000.hdop6(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():RegisterFlagEffect(77239000,RESET_EVENT+0x1fe0000,0,0)
		local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
		if g:GetCount()==0 then return end
		local sg=g:RandomSelect(1-tp,1)
		Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
	end
end
--------------------------------------------------------------------------
function c77239000.cfilter7(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL)
end
function c77239000.condition7(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c77239000.cfilter7,tp,LOCATION_MZONE,0,1,nil)
end
function c77239000.filter7(c)
	return c:IsDestructable()
end
function c77239000.target7(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c77239000.filter7(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c77239000.filter7,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c77239000.filter7,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c77239000.activate7(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
----------------------------------------------------------------------
function c77239000.cfilter8(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c77239000.condition8(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c77239000.cfilter8,tp,LOCATION_MZONE,0,1,nil)
end
function c77239000.setcon8(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsReason(REASON_BATTLE)
end
function c77239000.settg8(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,1)
end
function c77239000.setop8(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(1-tp,1,REASON_EFFECT)
end
-------------------------------------------------------------------------
function c77239000.filter9(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c77239000.atkcon9(e)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c77239000.filter9,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_WIND)
end
-----------------------------------------------------------------------
function c77239000.filter10(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c77239000.atkcon10(e)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c77239000.filter10,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_WATER)
end
-----------------------------------------------------------------------
function c77239000.filter11(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c77239000.condition11(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c77239000.filter11,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_FIRE)
end
function c77239000.target11(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*400)
end
function c77239000.operation11(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	Duel.Recover(p,ct*400,REASON_EFFECT)
end
-----------------------------------------------------------------------
function c77239000.filter12(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c77239000.condition12(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c77239000.filter12,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_EARTH)
end
function c77239000.target12(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*400)
end
function c77239000.operation12(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	Duel.Damage(p,ct*400,REASON_EFFECT)
end
-------------------------------------------------------------------------
function c77239000.filter13(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c77239000.condition13(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c77239000.filter13,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_LIGHT)
end
function c77239000.distg13(e,c)
    return c:IsType(TYPE_MONSTER)
end
-------------------------------------------------------------------------
function c77239000.filter14(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c77239000.condition14(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c77239000.filter14,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_DARK)
end
function c77239000.atlimit14(e,c)
    return c~=e:GetHandler():GetSummonType()~=SUMMON_TYPE_NORMAL and c:IsFaceup()
end
-------------------------------------------------------------------------
function c77239000.condition15(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev) and ep~=tp
end
function c77239000.target15(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c77239000.activate15(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
--------------------------------------------------------------------------
function c77239000.cfilter16(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c77239000.filter16(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c77239000.target16(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239000.filter16,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77239000.activate16(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77239000.filter16,tp,LOCATION_DECK,0,1,1,nil)
    local g1=Duel.GetMatchingGroup(c77239000.cfilter16,tp,LOCATION_SZONE+LOCATION_FZONE,0,nil)   
	if g:GetCount()>0 and g1:GetCount()>=1 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
-------------------------------------------------------------------------
function c77239000.condition17(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil,TYPE_SPELL+TYPE_TRAP)>=2
end
function c77239000.target17(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_DECK,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c77239000.activate17(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local rg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_DECK,nil)
    if rg:GetCount()>0 then
        Duel.ConfirmCards(tp,rg)
        local tg=Group.CreateGroup()               
        local tc=rg:Select(tp,1,1,nil):GetFirst()
        rg:Remove(Card.IsCode,nil,tc:GetCode())
        tg:AddCard(tc)
        Duel.SendtoGrave(tc,REASON_EFFECT)               
    end	
end
-------------------------------------------------------------------------
function c77239000.condition18(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil,TYPE_SPELL+TYPE_TRAP)>=3
end
-------------------------------------------------------------------------
function c77239000.condition19(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil,TYPE_SPELL+TYPE_TRAP)>=4
end
function c77239000.target19(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_DECK,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_DECK)
end
function c77239000.activate19(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local rg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_DECK,nil)
    if rg:GetCount()>0 then
        Duel.ConfirmCards(tp,rg)
        local tg=Group.CreateGroup()               
        local tc=rg:Select(tp,1,1,nil):GetFirst()
        rg:Remove(Card.IsCode,nil,tc:GetCode())
        tg:AddCard(tc)
         Duel.MoveSequence(tc,0)
    end	
end
------------------------------------------------------------------------
function c77239000.condition20(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil,TYPE_SPELL+TYPE_TRAP)>=5
end
function c77239000.target20(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeck(1-tp,1)
        and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_DECK,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
    local res=Duel.SelectOption(tp,70,71,72)
    e:SetLabel(res)
end
function c77239000.operation20(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) or not Duel.IsPlayerCanDiscardDeck(1-tp,1) then return end
    Duel.ConfirmDecktop(1-tp,1)
    local res=e:GetLabel()	
    local g=Duel.GetDecktopGroup(1-tp,1)
    local tc=g:GetFirst()
    Duel.ConfirmCards(tp,tc)
    if (res==0 and tc:IsType(TYPE_MONSTER)) or (res==1 and tc:IsType(TYPE_SPELL)) or (res==2 and tc:IsType(TYPE_TRAP)) then
        Duel.DisableShuffleCheck()
        Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	else
        Duel.DisableShuffleCheck()
	    Duel.SendtoHand(tc,nil,REASON_EFFECT)
	    Duel.ShuffleHand(1-tp)	
    end   
end
----------------------------------------------------------------------
function c77239000.discon21(e,tp,eg,ep,ev,re,r,rp)
	return  1-tp==Duel.GetTurnPlayer() and Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil,TYPE_SPELL+TYPE_TRAP)>=6
end
function c77239000.distg21(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,5)
end
function c77239000.disop21(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.DiscardDeck(1-tp,5,REASON_EFFECT)
end
-----------------------------------------------------------------------

