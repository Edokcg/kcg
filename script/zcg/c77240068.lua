--卡通奥西里斯之天空龙
function c77240068.initial_effect(c)
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c77240068.spcon)
    c:RegisterEffect(e2)
	
	--
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_ONFIELD,0)
    e3:SetTarget(c77240068.filter)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e4)

	--
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_CANNOT_DISEFFECT)
    e5:SetRange(LOCATION_MZONE)
    e5:SetValue(c77240068.chainfilter)
    c:RegisterEffect(e5)

    --direct attack
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_DIRECT_ATTACK)
    c:RegisterEffect(e6)
	
    --unaffectable
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCode(EFFECT_IMMUNE_EFFECT)
    e7:SetValue(c77240068.efilter)
    c:RegisterEffect(e7)

    --atk/def
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE)
    e8:SetCode(EFFECT_UPDATE_ATTACK)
    e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e8:SetRange(LOCATION_MZONE)
    e8:SetValue(c77240068.adval)
    c:RegisterEffect(e8)
    local e9=e8:Clone()
    e9:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e9)	
	
    --下降对手怪兽攻击、破坏
	local e10=Effect.CreateEffect(c)
	e10:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetDescription(aux.Stringid(10000020,1))
	e10:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCountLimit(10)
	e10:SetCode(EVENT_SUMMON_SUCCESS)
	e10:SetCondition(c77240068.atkcon)
	e10:SetTarget(c77240068.atktg)
	e10:SetOperation(c77240068.atkop)
	c:RegisterEffect(e10)
	local e11=e10:Clone()
	e11:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e11)
	local e12=e11:Clone()
	e12:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e12)
end
-------------------------------------------------------------------------
function c77240068.spfilter(c)
    return c:IsFaceup() and (c:IsCode(15259703) or c:IsCode(900000079) or c:IsCode(511001251))
end
function c77240068.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77240068.spfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end
-------------------------------------------------------------------------
function c77240068.filter(e,c)
    return c:IsFaceup() and (c:IsCode(15259703) or c:IsCode(900000079) or c:IsCode(511001251))
end
-------------------------------------------------------------------------
function c77240068.chainfilter(e,ct)
    local p=e:GetHandlerPlayer()
    local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
    local tc=te:GetHandler()
    return p==tp and tc:IsFaceup() and (tc:IsCode(15259703) or tc:IsCode(900000079) or tc:IsCode(511001251))
end
-------------------------------------------------------------------------
function c77240068.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
-------------------------------------------------------------------------
function c77240068.adval(e,c)
    return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)*1000
end
-------------------------------------------------------------------------
function c77240068.atkfilter(c,tp)
	return c:IsControler(tp) and c:IsPosition(POS_FACEUP)
end

function c77240068.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77240068.atkfilter,1,nil,1-tp)
end

function c77240068.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and s.atkfilter(chkc,tp) end
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetCard(eg:Filter(c77240068.atkfilter,nil,1-tp))
end

function c77240068.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	if g:GetCount()>0 then
	local tc=g:GetFirst()
	while tc do
		local preatk=tc:GetAttack()
		local predef=tc:GetDefense()
		if tc:GetPosition()==POS_FACEUP_ATTACK and preatk>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-2000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		if tc:GetAttack()==0 then dg:AddCard(tc) end end

		if tc:GetPosition()==POS_FACEUP_DEFENSE and predef>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(-2000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		if tc:GetDefense()==0 then dg:AddCard(tc) end end
		tc=g:GetNext()
	end
	Duel.Destroy(dg,REASON_RULE) end
end