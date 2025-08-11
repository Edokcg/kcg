--真龙魔王 大同矢·异教(neet)
local s,id=GetID()
function s.initial_effect(c)
	--link summon
	Link.AddProcedure(c,s.matfilter,2)
	c:EnableReviveLimit()  
	--Link Material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(1,0)
	e1:SetOperation(aux.TRUE)
	e1:SetValue(s.extraval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetCondition(s.addtypecon)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsContinuousSpellTrap))
	e2:SetValue(TYPE_MONSTER)
	c:RegisterEffect(e2)   
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end)
	e3:SetValue(aux.imval1)
	c:RegisterEffect(e3) 
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--Negate
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_MATERIAL_CHECK)
	e5:SetValue(s.valcheck)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,0))
	e6:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(s.negcon)
	e6:SetTarget(s.negtg)
	e6:SetOperation(s.negop)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
	--Register types
	aux.GlobalCheck(s,function()
		s.type_list={}
		s.type_list[0]=0
		s.type_list[1]=0
		aux.AddValuesReset(function()
				s.type_list[0]=0
				s.type_list[1]=0
			end)
		end)
end
function s.matfilter(c)
	return c:IsType(TYPE_EFFECT) or c:IsContinuousSpellTrap()
end
function s.extraval(chk,summon_type,e,...)
	if chk==0 then
		local tp,sc=...
		if summon_type~=SUMMON_TYPE_LINK or not (sc and sc:IsCode(id)) then
			return Group.CreateGroup()
		else
			Duel.RegisterFlagEffect(tp,id,0,0,1)
			return Duel.GetMatchingGroup(Card.IsContinuousSpellTrap,tp,LOCATION_SZONE,0,nil)
		end
	elseif chk==2 then
		Duel.ResetFlagEffect(e:GetHandlerPlayer(),id)
	end
end
function s.addtypecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),id)>0
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	local typ=0
	for tc in aux.Next(g) do
		typ=typ|(tc:GetOriginalType()&(TYPE_MONSTER|TYPE_SPELL|TYPE_TRAP))
	end
	e:SetLabel(typ)
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	local typ=e:GetLabelObject():GetLabel()
	local rc=re:GetHandler()
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and s.type_list[tp]&rc:GetOriginalType()==0 and rc:GetOriginalType()&typ>0
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	local relation=rc:IsRelateToEffect(re)
	if chk==0 then return rc:IsAbleToRemove(tp)
		or (not relation and Duel.IsPlayerCanRemove(tp)) end
	s.type_list[tp]=s.type_list[tp]|(rc:GetOriginalType()&(TYPE_MONSTER|TYPE_SPELL|TYPE_TRAP))
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if relation then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,rc,1,rc:GetControler(),rc:GetLocation())
	else
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,0,rc:GetPreviousLocation())
	end
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end