--Number CI1000: Numerronius Numerronia
local s, id = GetID()
function s.initial_effect(c)
	Xyz.AddProcedureX(c,s.xyzfilter,nil,2,nil,nil,Xyz.InfiniteMats,nil,false) 
	c:EnableReviveLimit()
	
	--cannot destroyed
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(s.indes)
	c:RegisterEffect(e0)

	--cannot special summon
	-- local e1=Effect.CreateEffect(c)
	-- e1:SetType(EFFECT_TYPE_SINGLE)
	-- e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	-- e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	-- c:RegisterEffect(e1) 
	
	--indestructible
	local e4=Effect.CreateEffect(c) 
	e4:SetType(EFFECT_TYPE_SINGLE) 
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE) 
	e4:SetRange(LOCATION_MZONE) 
	e4:SetCode(EFFECT_IMMUNE_EFFECT) 
	e4:SetValue(s.efilter) 
	c:RegisterEffect(e4) 
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)

	--自己场上怪兽不能成为攻击目标
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e7:SetTarget(s.beatktg)
	e7:SetValue(Auxiliary.imval1)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e8:SetValue(aux.tgoval)
	c:RegisterEffect(e8)
	
	--atk
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EFFECT_SET_ATTACK)
	e9:SetValue(s.atkval)
	c:RegisterEffect(e9)
	
	--disable attack
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(84013237,0))
	e10:SetCategory(CATEGORY_RECOVER)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCode(EVENT_ATTACK_ANNOUNCE)
	e10:SetCost(Cost.DetachFromSelf(1))
	e10:SetTarget(s.target)
	e10:SetOperation(s.atkop)
	c:RegisterEffect(e10)
end
s.xyz_number=100
s.listed_series = {0x48, 0x568}

function s.xyzfilter(c,xyz,sumtype,tp)
	return c:IsType(TYPE_XYZ,xyz,sumtype,tp) and c:IsSetCard(0x48,xyz,sumtype,tp) and c:IsSetCard(0x568,xyz,sumtype,tp)
end

function s.indes(e,c)
	return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) 
	  and not e:GetHandler():GetBattleTarget():IsSetCard(0x1048) and not e:GetHandler():GetBattleTarget():IsSetCard(0x2048)
end

function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function s.beatktg(e,c)
	return c~=e:GetHandler()
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(594)==0 then
	c:RegisterFlagEffect(594,RESET_EVENT+0x1fe0000,0,1)
	c:SetTurnCounter(0) end
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==2 then
	local WIN_REASON_CiNo100=0x52
	Duel.Win(tp,WIN_REASON_CiNo100)
	end
end

function s.atkval(e,c)
	return c:GetOverlayCount()*100000
end

function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetAttacker()
	if chk==0 then return tg:IsOnField() and tg:IsControler(1-tp) end
	Duel.SetTargetCard(tg)
	local rec=tg:GetAttack()
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:CanAttack() then
		if Duel.NegateAttack(tc) then
			Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
		end
	end
end